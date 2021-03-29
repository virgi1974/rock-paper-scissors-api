class AuthorizeApiRequest
  def initialize(headers = {})
    @headers = headers
  end

  # Service entry point - return valid user object
  def call
    { user: user }
  end

  private

  attr_reader :headers

  def user
    @user ||= User.find(decoded_auth_token[:id]) if decoded_auth_token
  rescue ActiveRecord::RecordNotFound => e
    raise(
      ExceptionHandler::InvalidToken,
      ("Invalid token #{e.message}")
    )
  end

  # decode authentication token
  def decoded_auth_token
    @decoded_auth_token ||= JsonWebToken.decode(auth_header)
  end

  # check for token in `Authorization` header
  def auth_header
    return headers['Authorization'].split(' ').last if auth_header?

    raise(ExceptionHandler::MissingToken, 'Missing token')
  end

  def auth_header?
    headers['Authorization'].present?
  end
end