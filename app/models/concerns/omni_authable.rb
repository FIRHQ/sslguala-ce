# frozen_string_literal: true

module OmniAuthable
  extend ActiveSupport::Concern

  def bind?(provider)
    user_omniauths.collect(&:provider).include?(provider)
  end

  def bind_service(provider, uid)
    user_omniauths.find_or_create_by(provider: provider, uid: uid).try(:user)
  end

  module ClassMethods
    def from_omniauth(provider, uid, email = nil, name = '', opts = {})
      user = UserOmniauth.find_by(provider: provider, uid: uid).try(:user)
      return user if user
      return user if email.present? && user = User.find_by(email: email)

      new_user = User.new do |user|
        user.email = email || "#{SecureRandom.uuid}@example-#{provider}.com"
        user.password = Devise.friendly_token[0, 20]
        user.first_name = name
      end

      new_user.save
      new_user.user_omniauths.find_or_create_by(provider: provider, uid: uid)
      new_user
    end
  end
end
