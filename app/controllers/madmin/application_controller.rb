module Madmin
  class ApplicationController < Madmin::BaseController
    before_action :authenticate_user!
    before_action :authenticate_admin_user
    
    def authenticate_admin_user
      unless current_user.admin?
        sign_out
        redirect_to new_user_session_path, notice: '您账号没有管理员权限'
      end
    end

    # Authenticate with Clearance
    # include Clearance::Controller
    # before_action :require_login

    # Authenticate with Devise
    # before_action :authenticate_user!

    # Authenticate with Basic Auth
    # http_basic_authenticate_with(name: Rails.application.credentials.admin_username, password: Rails.application.credentials.admin_password)
  end
end
