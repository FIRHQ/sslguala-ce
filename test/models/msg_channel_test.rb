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
require "test_helper"

class MsgChannelTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
