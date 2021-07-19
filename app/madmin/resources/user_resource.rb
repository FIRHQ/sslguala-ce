class UserResource < Madmin::Resource
  # Attributes
  attribute :id, form: false
  attribute :email
  #attribute :password
  # attribute :encrypted_password, form: false
  # attribute :reset_password_token, form: false
  # attribute :reset_password_sent_at, form: false
  # attribute :remember_created_at, form: false
  attribute :first_name
  attribute :last_name
  attribute :admin
  attribute :created_at, form: false
  # attribute :updated_at, form: false

  # Associations
  attribute :check_domains
  attribute :projects

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
