class CreateDomainMsgChannels < ActiveRecord::Migration[6.1]
  def change
    create_table :domain_msg_channels do |t|
      t.references :check_domain, null: false, foreign_key: true
      t.references :msg_channel, null: false, foreign_key: true

      t.timestamps
    end
  end
end
