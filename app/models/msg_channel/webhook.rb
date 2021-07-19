class MsgChannel::Webhook < MsgChannel
  validates_presence_of :url


  def send_msg(title, body)
    payload = {
      "title": title,
      "description": body,
      "url": 'https://sslguala.com'
    }
    DefaultRest.post(url, payload)
	rescue
  end
end
