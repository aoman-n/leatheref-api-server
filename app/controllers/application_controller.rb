class ApplicationController < ActionController::API
  include ActionController::HttpAuthentication::Token::ControllerMethods
  include ResponseModule
  include SessionsHelper

  # unless Rails.env.development?
  rescue_from Exception, with: :custom_error_500
  rescue_from ActiveRecord::RecordNotFound, with: :custom_error_404
  rescue_from ActionController::RoutingError, with: :custom_error_404
  # end

  def hello
    puts 'hello!'
    log('log helper')
    puts Rails.application.credentials.test_key_base
    render json: { text: 'Hello World' }
  end

  private

  def logged_in_user
    response_unauthorized unless logged_in?
  end
end
