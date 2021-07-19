class AddErrorInfoToMsgChannel < ActiveRecord::Migration[6.1]
  def change
    add_column :msg_channels, :error_info, :string
  end
end
