# == Schema Information
#
# Table name: user_omniauths
#
#  id         :bigint           not null, primary key
#  nickname   :string
#  provider   :string           not null
#  uid        :string
#  unionid    :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  user_id    :integer          not null
#
# Indexes
#
#  index_user_omniauths_on_provider_and_uid  (provider,uid)
#
require "test_helper"

class UserOmniauthTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
