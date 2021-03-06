# == Schema Information
#
# Table name: check_domains
#
#  id                   :bigint           not null, primary key
#  check_expire_time_at :datetime
#  domain               :string
#  expire_at            :datetime
#  latest_notice_at     :datetime
#  markup               :string
#  notice_info          :jsonb
#  status               :string
#  created_at           :datetime         not null
#  updated_at           :datetime         not null
#  project_id           :integer
#  user_id              :bigint           not null
#
# Indexes
#
#  index_check_domains_on_user_id  (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (user_id => users.id)
#
require "test_helper"

class CheckDomainTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
