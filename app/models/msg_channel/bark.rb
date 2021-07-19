class MsgChannel::Bark < MsgChannel
  validates_presence_of :url

  def send_msg(title, body)
    payload = {
      "title": title,
      "body": body,
      "url": 'https://sslguala.com'
    }
    DefaultRest.post(url, payload)
	rescue
  end
end
