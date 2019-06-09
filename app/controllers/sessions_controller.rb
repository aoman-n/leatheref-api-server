class SessionsController < ApplicationController
  def create
    auth = request.env['omniauth.auth']
    if auth.present?
      user = User.find_or_create_from_auth(request.env['omniauth.auth'])
      user.activate unless user.activated?
      j_token = create_token_for_login(user)
      render json: { token: j_token }
    else
      user = User.find_by(email: params[:email])
      if user.blank?
        response_not_found(:user)
      elsif user.authenticate(params[:password]) && user.activated?
        j_token = create_token_for_login(user)
        render json: { token: j_token }
      else
        response_unauthorized
      end
    end
  end

  def destroy
    if logged_in?
      log_out
      render json: { message: 'success log out' }
    else
      response_bad_request
    end
    # log_out if logged_in?
    # render json: { message: "success log out" }
  end
end
