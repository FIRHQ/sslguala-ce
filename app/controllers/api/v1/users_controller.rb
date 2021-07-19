class Api::V1::UsersController < ApiController
  def info
    @user = current_user
  end

  def reset_token
    current_user.reset_api_token
    render json: { api_token: current_user.reload.api_token }
  end
end
