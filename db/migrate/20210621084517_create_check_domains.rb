class CreateCheckDomains < ActiveRecord::Migration[6.1]
  def change
    create_table :check_domains do |t|
      t.string :domain
      t.string :markup
      t.datetime :expire_at
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
