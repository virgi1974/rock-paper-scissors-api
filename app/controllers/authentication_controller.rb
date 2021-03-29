class AuthenticationController < ApplicationController
  skip_before_action :authorize_request, only: :authenticate

  def authenticate
    generated_user_token = JsonWebToken.encode(id: user.id) if user

    if generated_user_token
      render json: { token: generated_user_token }
    else
      render json: { error: 'Invalid params' }, status: :unauthorized
    end
  end

  private

  def auth_params
    params.permit(:email, :password, {})
  end

  def user
    user = User.find_by(email: auth_params[:email])
    return user if user && user.authenticate(auth_params[:password])
    
    raise(ExceptionHandler::AuthenticationError, 'Invalid credentials')
  end
end
