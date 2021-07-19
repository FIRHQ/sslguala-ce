# == Schema Information
#
# Table name: users
#
#  id                     :bigint           not null, primary key
#  admin                  :boolean          default(FALSE)
#  api_token              :string
#  email                  :string           default(""), not null
#  encrypted_password     :string           default(""), not null
#  first_name             :string
#  last_name              :string
#  remember_created_at    :datetime
#  reset_password_sent_at :datetime
#  reset_password_token   :string
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#
# Indexes
#
#  index_users_on_api_token             (api_token)
#  index_users_on_email                 (email) UNIQUE
#  index_users_on_reset_password_token  (reset_password_token) UNIQUE
#
class User < ApplicationRecord
  include OmniAuthable
  attr_accessor :login
  has_person_name

  has_many :check_domains
  has_many :projects
  has_many :user_omniauths
  has_many :msg_channels

  before_create :set_init
  after_create :create_project


  def set_init
    self.api_token = SecureRandom.uuid
  end

  def reset_api_token
    Rails.cache.write("user_api_token:#{id}", api_token, expires_in: 7.days)
    update(api_token: SecureRandom.uuid)
  end

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :jwt_authenticatable, :omniauthable, omniauth_providers: %i[wechat], jwt_revocation_strategy: Devise::JWT::RevocationStrategies::Null


  def self.find_for_database_authentication(warden_conditions)
    conditions = warden_conditions.dup
    if login = conditions.delete(:login)
      return if login.blank?

      where(email: login).first
    end
  end

  def create_project
    projects.create(name: "默认分组")
  end
end
