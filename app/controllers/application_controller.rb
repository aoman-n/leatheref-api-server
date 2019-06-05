class ApplicationController < ActionController::API
  include ActionController::HttpAuthentication::Token::ControllerMethods
  include SessionsHelper

  # unless Rails.env.development?
    rescue_from Exception, with: :custom_error_500
    rescue_from ActiveRecord::RecordNotFound, with: :custom_error_404
    rescue_from ActionController::RoutingError, with: :custom_error_404
  # end

  def hello
    puts 'hello!'
    log('log helper')
    render json: { text: 'Hello World' }
  end

  private

    # 200 Success
    def response_success(class_name, action_name)
      render status: 200, json: { status: 200, message: "Success #{class_name.capitalize} #{action_name.capitalize}" }
    end

    # 400 Bad Request
    def response_bad_request
      render status: 400, json: { status: 400, message: 'Bad Request' }
    end

    # 401 Unauthorized
    def response_unauthorized
      render status: 401, json: { status: 401, message: 'Unauthorized' }
    end

    # 404 Not Found
    def response_not_found(class_name = 'page')
      render status: 404, json: { status: 404, message: "#{class_name.capitalize} Not Found" }
    end

    def custom_error_404(error = nil)
      logger.info "Rendering 404 with exception: #{error.message}" if error
      render status: 404, json: { status: 404, message: "Not Found" }
    end

    # 409 Conflict
    def response_conflict(class_name)
      render status: 409, json: { status: 409, message: "#{class_name.capitalize} Conflict" }
    end

    # 500 Internal Server Error
    def response_internal_server_error
      render status: 500, json: { status: 500, message: 'Internal Server Error' }
    end

    def custom_error_500(error = nil)
      logger.error "Rendering 500 with exception: #{error.message}" if error
      render status: 500, json: { status: 500, message: "Internal Server Error #{error}" }
    end

    def logged_in_user
      unless logged_in?
        response_unauthorized
      end
    end

end
