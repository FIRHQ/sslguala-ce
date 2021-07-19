class AddAttributesToMsgChannels < ActiveRecord::Migration[6.1]
  def change
    add_reference :msg_channels, :user, null: false, foreign_key: true
    add_column :msg_channels, :is_common, :boolean, default: true
  end
end
