class AddCheckDomainsCountToProjects < ActiveRecord::Migration[6.1]
  def change
    add_column :projects, :check_domains_count, :integer
  end
end
