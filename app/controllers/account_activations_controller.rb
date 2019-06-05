class AccountActivationsController < ApplicationController

  def edit
    user = User.find_by(email: params[:email])
    if user && !user.activated? && user.authenticated?(:activation, params[:id])
      user.activate
      j_token = create_token_for_login(user)
      render json: { message: "Account activated!!", token: j_token }
    else
      render json: { message: "Invalid activation link" }, status: 400
    end
  end

end
