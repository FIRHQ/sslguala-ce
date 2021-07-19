class AddStatusToCheckDomains < ActiveRecord::Migration[6.1]
  def change
    add_column :check_domains, :status, :string
  end
end
