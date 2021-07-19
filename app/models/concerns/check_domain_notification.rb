module CheckDomainNotification
  extend ActiveSupport::Concern

	class_methods do
		def send_channels_msg(id, title, content)
			check_domain = find id
			return if check_domain.nil?

			# 取关联的channel以及默认的channel
			channels = check_domain.msg_channels# + check_domain.user.msg_channels.default_list
			channels.uniq.each do |msg_channel|
				msg_channel.send_msg(title, content)
			end
		end
	end


  def try_send_expire_notification(async: true)
    return unless expired?
    return if latest_notice_at.to_i >= expire_at.to_i # 已经过期, 且通知了一次

    title = "域名 #{domain} 证书已过期, 请立即更新证书"
    content = <<-EOF
    域名 #{domain} 证书过期时间为 #{expire_at.localtime}

    详情请访问 https://www.sslguala.com/projects/#{project_id}/domains/#{id}/details 查看
    EOF

    if async
      self.class.delay(retry: 1).send_channels_msg(id, title, content)
    else
      self.class.send_channels_msg(id, title, content)
    end
    self.class.where(id: id).update_all(latest_notice_at: Time.current)
    true
  end

  def try_send_expire_soon_notification(async: true, ignore_days_limit: false)
    return false if expired?

    days = remain_days
    return unless [14, 7, 3, 1, 0].include?(days) || ignore_days_limit

    Rails.cache.fetch("check-domain-#{id}-days-#{days}", expires_in: 25.hours) do
      send_expire_soon_notification(days, async: async)
      self.class.where(id: id).update_all(latest_notice_at: Time.current)
    end
  end

  def send_expire_soon_notification(day, async: true)
    title = "域名 #{domain} 证书还有#{day}天过期, 请立即更新证书"
    content = <<-EOF
    域名 #{domain} 证书过期时间为 #{expire_at.localtime}, 还有#{remain_days}天过期

    详情请访问 https://www.sslguala.com/# 查看
    EOF
    if async
      self.class.delay(retry: 1).send_channels_msg(id, title, content)
    else
      self.class.send_channels_msg(id, title, content)
    end
    true
  end

  def send_recover_notification(async: true)
    title = "域名 #{domain} 证书已更新成功, 证书还有#{remain_days}天过期。"
    Rails.logger.info("notice => #{title}")
    content = <<-EOF
    域名 #{domain} 证书过期时间为 #{expire_at.localtime}, 还有#{remain_days}天过期
    详情请访问 https://www.sslguala.com 查看
    EOF
    if async
      self.class.delay(retry: 1).send_channels_msg(id, title, content)
    else
      self.class.send_channels_msg(id, title, content)
    end
    true
  end
end