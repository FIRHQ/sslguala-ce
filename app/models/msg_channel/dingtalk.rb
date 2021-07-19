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
class MsgChannel::Dingtalk < MsgChannel
  validates_presence_of :url

  validate :check_url

  def send_msg(title = "ssl", body = 'good')    
    payload = {
      "msgtype": 'markdown',
      "markdown": {
        "title": title,
        "text": body
      }
    }
    
    dingtalk_url = url
    if config_secret.present?
      info = secret_cal(config_secret)      
      dingtalk_url = "#{dingtalk_url}&timestamp=#{info[:timestamp]}&sign=#{info[:sign]}"
    end
    
    answer = DefaultRest.post(dingtalk_url, payload)
    send_status_log({status: answer[:errcode] == 0, error: answer})
  rescue StandardError => e
    Rails.logger.info("url => #{dingtalk_url}, error => #{e}")
    send_status_log({status: false, error: e})
    { error: e }
  end

  def check_url    
    errors.add(:url, "请填写钉钉的URL") unless url.start_with?('https://oapi.dingtalk.com/robot/send')    
  end

  private

  def secret_cal(secret)
    timestamp = Time.now.to_i * 1000
    secret_enc = secret.encode('utf-8')
    str = "#{timestamp}\n#{secret}"
    string_to_sign_enc = str.encode('utf-8')

    hmac = OpenSSL::HMAC.digest(OpenSSL::Digest.new('sha256'), secret_enc, string_to_sign_enc)
    {
      timestamp: timestamp,
      sign: CGI.escape(Base64.encode64(hmac).strip)
    }
  end
end
