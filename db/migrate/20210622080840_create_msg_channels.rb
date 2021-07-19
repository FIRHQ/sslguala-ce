class CreateMsgChannels < ActiveRecord::Migration[6.1]
  def change
    create_table :msg_channels do |t|
      t.string :title
      t.string :url
      t.string :type
      t.string :markup
      t.jsonb :config

      t.timestamps
    end
  end
end
