module ControllerSpecHelper
  def token_generator(user_id)
    JsonWebToken.encode(id: user_id)
  end
end