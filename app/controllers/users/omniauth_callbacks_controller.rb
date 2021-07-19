# frozen_string_literal: true
require 'devise/jwt/test_helpers'

class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController
  skip_before_action :verify_authenticity_token#, only: :wechat

  def wechat
    auth = request.env['omniauth.auth']
    Rails.logger.info("====> wechat #{auth}")
    unionid = auth['info']['unionid']
    user = bind_omniauth('wechat', auth['uid'])
    info = auth['info']
    @user = user || User.from_omniauth('wechat', auth['uid'], nil, info['nickname'], avatar: info['headimgurl'], unionid: info['unionid'])

    redirect_oauth(@user)
  end

  def redirect_oauth(user)
    url = "#{ENV['WEB_DOMAIN']}/auth/callback"
    url = if user&.persisted?
            sign_in(resource_name, user)
            headers = auth_headers(user)
            "#{url}?server_token=#{headers['Authorization']}"
          else
            "#{url}?error=#{user.errors.messages}"
          end
    redirect_to url
  end

  def failure
    redirect_to "#{ENV['WEB_DOMAIN']}"
  end

  def bind_omniauth(provider, uid)
    return current_user if current_user.present? && current_user.bind_service(provider, uid)
  end

  # 生成新的token
  def auth_headers(user)
    headers = { 'Accept' => 'application/json', 'Content-Type' => 'application/json' }
    auth_headers = Devise::JWT::TestHelpers.auth_headers(headers, user)
  end
end
