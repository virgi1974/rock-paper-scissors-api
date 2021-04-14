class JsonWebToken
  ALGORITHM_SECRET = Rails.application.secrets.secret_key_base

  def self.encode(payload, expires_in = 24.hours.from_now)
    payload[:exp] = expires_in.to_i
    JWT.encode(payload, ALGORITHM_SECRET)
  end

  def self.decode(token)
    body = JWT.decode(token, ALGORITHM_SECRET)[0]
    body.with_indifferent_access
  rescue JWT::DecodeError => e
    raise ExceptionHandler::InvalidToken, e.message
  end
end