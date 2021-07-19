class CreateUserOmniauths < ActiveRecord::Migration[6.1]
  def change
    create_table :user_omniauths do |t|
      t.string :nickname
      t.string :provider, null: false
      t.string :uid
      t.string :unionid
      t.integer :user_id, null: false

      t.timestamps
    end

    add_index :user_omniauths, [:provider, :uid]
  end
end
