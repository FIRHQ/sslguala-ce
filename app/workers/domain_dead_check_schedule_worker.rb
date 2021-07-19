require 'sidekiq-scheduler'

class DomainDeadCheckScheduleWorker
  include Sidekiq::Worker

  def perform
    # 当前过期时间超过30天则，不再进行检测，设置状态为dead
    time_days = 30.days.ago
    need_check_domains = CheckDomain.all.where(status: :enabled).where("expire_at < ?", time_days)
    need_check_domains.each do |check_domain|
      need_check_domains.update(status: :dead)
    end
  end
end