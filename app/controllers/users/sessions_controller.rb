# frozen_string_literal: true

class Users::SessionsController < Devise::SessionsController
  before_action :configure_permitted_parameters, if: :devise_controller?
  respond_to :html, :json

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_in, keys: [:login, :email, :password, :password_confirmation])
   end
   
  protect_from_forgery with: :null_session, prepend: true
  before_action :configure_sign_in_params, only: [:create]

  # GET /resource/sign_in
  def new
    super
  end

  # POST /resource/sign_in
  def create
    super    
  end

  # DELETE /resource/sign_out
  def destroy
    super
  end

  # protected

  # def respond_with(resource, _opts = {})
    # render json: resource
  # end

  # If you have extra params to permit, append them to the sanitizer.
  def configure_sign_in_params
    devise_parameter_sanitizer.permit(:sign_in, keys: [:login, :email, :password])
  end
end
