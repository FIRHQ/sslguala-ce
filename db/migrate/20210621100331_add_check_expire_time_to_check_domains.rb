class AddCheckExpireTimeToCheckDomains < ActiveRecord::Migration[6.1]
  def change
    add_column :check_domains, :check_expire_time_at, :datetime
    add_column :check_domains, :project_id, :integer
  end
end
