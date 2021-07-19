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
class MsgChannel::Lark < MsgChannel
  validates_presence_of :url

  validate :check_url

  def send_msg(title, body)
    payload = build_v2_info(title, body)
    answer = DefaultRest.post(url, payload, { timeout: ENV['FEISHU_TIMEOUT'] ? ENV['FEISHU_TIMEOUT'].to_i : 30 })    
    send_status_log({status: answer[:StatusCode] == 0, error: answer})
  rescue => e
    send_status_log({status: false, error: e})
    { error: e}
  end

  # https://open.feishu.cn/open-apis/bot/v2/hook/901340c5-39ff-4fe4-a2e6-e151c0a28247
  def check_url    
    errors.add(:url, "请填写的飞书URL") unless url.start_with?('https://open.feishu.cn/')
  end

  # private

  def build_v2_info(title, body)
    answer = {
      msg_type: 'post',
      content: {
        post: {
          zh_cn: {
            title: title,
            content: [[{ "tag": 'text', "text": body }]]
          }
        }
      }
    }
    unless config_secret.blank?
      secret_info = secret_cal(config_secret)
      answer = answer.merge(secret_info)
    end
    answer
  end

  def secret_cal(secret)
    timestamp = Time.now.to_i
    str = "#{timestamp}\n#{secret}"
    string_to_sign_enc = str.encode('utf-8')

    hmac = OpenSSL::HMAC.digest(OpenSSL::Digest.new('sha256'), string_to_sign_enc, "")
    {
      timestamp: timestamp.to_s,
      sign: Base64.encode64(hmac).strip
    }
  end
end
