# == Schema Information
#
# Table name: check_domains
#
#  id                   :bigint           not null, primary key
#  check_expire_time_at :datetime
#  domain               :string
#  expire_at            :datetime
#  latest_notice_at     :datetime
#  markup               :string
#  notice_info          :jsonb
#  status               :string
#  created_at           :datetime         not null
#  updated_at           :datetime         not null
#  project_id           :integer
#  user_id              :bigint           not null
#
# Indexes
#
#  index_check_domains_on_user_id  (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (user_id => users.id)
#
class CheckDomain < ApplicationRecord
  include CheckDomainSsl
  include CheckDomainNotification
  enum status: {
    enabled: 'enabled',
    ignored: 'ignored',
    dead: 'dead'
  }, _default: 'enabled'

  belongs_to :user
  belongs_to :project, optional: true, counter_cache: true
  has_many :domain_msg_channels, dependent: :destroy
  has_many :msg_channels, through: :domain_msg_channels

  validates :domain, presence: true
  validate :check_domain, on: :create

  before_create :check_project
  before_create :strip_domain

  after_create :update_check_expire_time
  after_update_commit :check_send_msg_channels
  after_update_commit :ssl_recover

  def ask_expire_time
    self.class.ask_expire_time(domain)
  end

  def expired?
    expire_at < Time.current
  end

  def expire_soon?
    expire_time -  Time.current < 7.days
  end

  def update_check_expire_time
    self.expire_at = ask_expire_time
    self.check_expire_time_at = Time.current
    save!
  end

  def async_check_expire_time(random_waiting: false)
    if random_waiting
      self.class.delay_for(SecureRandom.rand(1..60).seconds, retry: false).check_domain_expire_time(domain)
    else
      self.class.delay.check_domain_expire_time(domain)
    end
  end

  def remain_days
    (expire_at.to_i - Time.current.to_i ) / (3600 * 24)
  end

  # 当expire_at变化，并且过期时间比当前长的话。发送通知为ssl的状态已更新通知
  def ssl_recover
    if saved_change_to_expire_at? && expire_at > expire_at_before_last_save
      send_recover_notification(async: true)
      clear_domain_cache
      update(status: :enabled) if status == 'dead'
    end
  end

  def clear_domain_cache
    [14, 7, 3, 1, 0].each { |days| Rails.cache.delete("check-domain-#{id}-days-#{days}") }
  end

  class << self
    def batch_create(user, domains, project_id, markup)
      exist_domains = user.check_domains.where(domain: domains.uniq)

      new_domain_objects = (domains.uniq - exist_domains.pluck(:domain)).map do |domain|
        user.check_domains.create(project_id: project_id, domain: domain, markup: markup)
      end

      {
        new_domains: new_domain_objects
      }
    end

    def parse_domain(domain)
      domain = domain.strip.downcase
      domain_url = "#{domain}".start_with?(/(http|https):\/\//) ? domain : "https://#{domain}"
      host = URI.parse(domain_url).host
      return '' unless PublicSuffix.valid?(host)

      clear_domain = PublicSuffix.parse(host).subdomain || PublicSuffix.parse(host).domain
      clear_domain
    end

    def check_domain_expire_time(domain)
      expire_time = ask_expire_time(domain)
      now = Time.current

      CheckDomain.where(domain: domain).each do |check_domain|
        check_domain.update(expire_at: expire_time, check_expire_time_at: now) unless check_domain.dead?
      end
    end

    def ask_expire_time(url)
      info = ssl_cert(url)
      info.not_after
    end
  end

  private

  def check_project
    self.project_id = user.projects.first&.id if project_id.nil?
  end

  def check_send_msg_channels
    # 如果不是检查域名引起的提交, 则直接返回
    return unless saved_change_to_check_expire_time_at?

    send_warn_msg
  end

  def strip_domain
    self.domain = parse_domain.downcase
  end

  def check_domain
    errors.add(:domain, "请填写合法的域名") if parse_domain.blank?
    errors.add(:domain, "您已创建过相同的域名") if CheckDomain.where(domain: parse_domain, user: user).exists?
  end

  def parse_domain
    self.class.parse_domain(self.domain)
  end

  def send_warn_msg
    if expired?
      # 发送过期通知
      try_send_expire_notification
    else
      # 快要过期, 发送通知
      try_send_expire_soon_notification
    end
  end

end
