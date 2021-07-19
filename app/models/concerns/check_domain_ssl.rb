module CheckDomainSsl
  extend ActiveSupport::Concern

  class_methods do
    def ssl_cert(url)
      http = if url.start_with? 'http'
               uri = URI.parse(url)
               Net::HTTP.new(uri.host, uri.port)
             else
               Net::HTTP.new(url.split('/')[0], 443)
             end

      http.use_ssl      = true
      # http.ssl_version  = :TLSv1
      http.verify_mode  = OpenSSL::SSL::VERIFY_NONE
      http.open_timeout = 20
      http.read_timeout = 20
      http.ssl_timeout  = 20

      http.start do |h|
        @cert = h.peer_cert
      end
      raise UrlError, 'No https found' if @cert.nil?

      @cert
    rescue SocketError, SystemCallError
      raise UrlError, "Bad URL? #{$!.message}"
    rescue Net::OpenTimeout
      raise UrlError, "访问链接 #{url} 超时，请确认网站能使用https访问"
    rescue OpenSSL::SSL::SSLError
      raise UrlError, "#{http.address} SSL config Error"
    end
  end
end