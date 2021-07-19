# == Schema Information
#
# Table name: msg_channels
#
#  id         :bigint           not null, primary key
#  config     :jsonb
#  error_info :string
#  is_common  :boolean          default(TRUE)
#  is_default :boolean          default(FALSE)
#  markup     :string
#  title      :string
#  type       :string
#  url        :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  user_id    :bigint           not null
#
# Indexes
#
#  index_msg_channels_on_is_default  (is_default)
#  index_msg_channels_on_user_id     (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (user_id => users.id)
#
class MsgChannel < ApplicationRecord
  store :config, accessors: %i[token secret custom_string email], prefix: :config

  belongs_to :user
  has_many :domain_msg_channels
  has_many :check_domains, through: :domain_msg_channels

  scope :default_list, -> { where(is_default: true)}

  # 记录发送状态
  def send_status_log(answer = {status: true, error: ''})
    if answer[:status]
      update(error_info: nil)
      true
    else
      update(error_info: answer[:error])
      false
    end  
  end

  def bind_domain(domain_id)
    domain = user.check_domains.find_by_id domain_id
    return if domain.nil?

    DomainMsgChannel.create(msg_channel: self, check_domain: domain)
  end

  def unbind_domain(domain_id)
    domain = user.check_domains.find_by_id domain_id
    return if domain.nil?

    DomainMsgChannel.where(msg_channel: self, check_domain: domain).each(&:destroy)
  end
end
