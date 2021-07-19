class AddNotifierToCheckDomains < ActiveRecord::Migration[6.1]
  def change
    add_column :check_domains, :latest_notice_at, :datetime
    add_column :check_domains, :notice_info, :jsonb
  end
end
