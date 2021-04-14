# frozen_string_literal: true
class ApplicationController < ActionController::API
  include ExceptionHandler

  before_action :authorize_request

  attr_reader :current_user

  private

  # Check that request uses valid token from a DB user
  def authorize_request
    @current_user = (AuthorizeApiRequest.new(request.headers).call)[:user]
    raise(ExceptionHandler::AuthenticationError, 'Credentials not valid') unless @current_user
  end
end
