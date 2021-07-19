class MsgChannelResource < Madmin::Resource
  # Attributes
  attribute :id, form: false
  attribute :title
  attribute :url
  attribute :type
  attribute :markup
  attribute :config
  attribute :created_at, form: false
  attribute :updated_at, form: false
  attribute :is_common
  attribute :error_info
  attribute :is_default

  # Associations
  attribute :user
  attribute :domain_msg_channels
  attribute :check_domains

  # Uncomment this to customize the display name of records in the admin area.
  # def self.display_name(record)
  #   record.name
  # end

  # Uncomment this to customize the default sort column and direction.
  # def self.default_sort_column
  #   "created_at"
  # end
  #
  # def self.default_sort_direction
  #   "desc"
  # end
end
