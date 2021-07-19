class EmailService

  class << self
    def app_authen
      ENV['TUBECENTER_APP_TOKEN'].presence
    end

    def send!(from:, to:, title:, content: )
      data = {
        from: from,
        to: to,
        title: title,
        content: content,
        app_authen: app_authen
      }

      res = DefaultRest.post(ENV['TUBECENTER_APP_URL'], data)
      Rails.logger.info("send email status => #{res}")
      res[:to] == to
    end
  end  
end
