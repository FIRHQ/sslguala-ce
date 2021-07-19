class ApiController < ActionController::Base
  protect_from_forgery unless: -> { request.format.json? || request.format.xml? }
  before_action :check_user
  before_action :auth_user!, unless: -> { Rails.env.development? }
  # before_action :authenticate_user!, unless: -> { Rails.env.development? }

  include Pagy::Backend

  def check_user
    @current_user = User.first if Rails.env.development?
  end

  def auth_user!
    # api_token = params[:api_token]
    # if api_token.present? && user = User.find_by(api_token: api_token)
    #   return @current_user = user
    # end
    authenticate_user!
  end
end
