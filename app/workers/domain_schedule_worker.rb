require 'sidekiq-scheduler'

class DomainScheduleWorker
  include Sidekiq::Worker

  def perform
    need_check_domains = CheckDomain.all.where(status: :enabled)
    need_check_domains.each do |check_domain|
      check_domain.async_check_expire_time(random_waiting: true)
    end
  end
end