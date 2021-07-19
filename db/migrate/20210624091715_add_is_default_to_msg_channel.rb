class AddIsDefaultToMsgChannel < ActiveRecord::Migration[6.1]
  def change
    add_column :msg_channels, :is_default, :boolean, default: false
    add_index :msg_channels, :is_default
  end
end
