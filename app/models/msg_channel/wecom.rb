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
class MsgChannel::Wecom < MsgChannel
  validates_presence_of :url

  validate :check_url

  def send_msg(title, body)
    payload = {
      "msgtype": 'news',
      "news": {
        "articles": [{
          "title": title,
          "description": body,
          "url": 'https://sslguala.com'
        }]
      }      
    }
    
    answer = DefaultRest.post(url, payload)
    send_status_log({status: answer[:errcode] == 0, error: answer})
  rescue => e
    send_status_log({status: false, error: e})
    { error: e}
  end

  def check_url    
    errors.add(:url, "请填写的企业微信的URL") unless url.start_with?('https://qyapi.weixin.qq.com/')
  end
end
