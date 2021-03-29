module ExceptionHandler
  extend ActiveSupport::Concern

  class AuthenticationError < StandardError; end
  class MissingToken < StandardError; end
  class InvalidToken < StandardError; end

  included do
    rescue_from ActiveRecord::RecordInvalid, with: :four_twenty_two
    rescue_from ExceptionHandler::AuthenticationError, with: :unauthorized_request
    rescue_from ExceptionHandler::MissingToken, with: :four_twenty_two
    rescue_from ExceptionHandler::InvalidToken, with: :four_twenty_two
    rescue_from ActiveRecord::RecordNotFound, with: :not_found
  end
  
  private
  
  def not_found(e)
    @error = e.message
    render template: error_template, status: :not_found
  end
  
  # JSON response with message; Status code 422 - unprocessable entity
  def four_twenty_two(e)
    @error = e.message
    render template: error_template, status: :unprocessable_entity
  end
  
  # JSON response with message; Status code 401 - Unauthorized
  def unauthorized_request(e)
    @error = e.message
    render template: error_template, status: :unauthorized
  end

  def error_template
    'error.json.jbuilder'
  end
end