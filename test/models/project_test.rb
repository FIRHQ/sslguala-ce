# == Schema Information
#
# Table name: projects
#
#  id                  :bigint           not null, primary key
#  check_domains_count :integer
#  description         :string
#  name                :string
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#  user_id             :bigint
#
# Indexes
#
#  index_projects_on_user_id  (user_id)
#
require "test_helper"

class ProjectTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
