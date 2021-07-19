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
class MsgChannel::Email < MsgChannel
  validates :config_email, presence: true
  validates :config_email, format: { with: /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/i }
  
  def send_msg(title, body)
    return if config_email.blank?

    answer = EmailService.send!(from: ENV['TUBECENTER_APP_USEREMAIL'], to: config_email, title: title, content: body)
    answer = { status: answer}
    send_status_log({status: answer, error: answer})
  rescue StandardError => e    
    send_status_log({status: false, error: e})
    {error: e}
  end
end
