# == Schema Information
#
# Table name: domain_msg_channels
#
#  id              :bigint           not null, primary key
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  check_domain_id :bigint           not null
#  msg_channel_id  :bigint           not null
#
# Indexes
#
#  index_domain_msg_channels_on_check_domain_id  (check_domain_id)
#  index_domain_msg_channels_on_msg_channel_id   (msg_channel_id)
#
# Foreign Keys
#
#  fk_rails_...  (check_domain_id => check_domains.id)
#  fk_rails_...  (msg_channel_id => msg_channels.id)
#
class DomainMsgChannel < ApplicationRecord
  belongs_to :check_domain
  belongs_to :msg_channel

end
