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
class Project < ApplicationRecord
  has_many :check_domains
  belongs_to :user
  before_destroy :check_project_destroy

  private

  def check_project_destroy
    if user.projects.order("created_at asc").first.id == id
      errors.add("id", "默认项目不能删除")
      throw(:abort) if errors.present?
    end
  end
end
