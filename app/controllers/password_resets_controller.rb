class PasswordResetsController < ApplicationController
  before_action :get_user, only: [:create, :update]
  before_action :valid_user, only: :update
  before_action :check_expiration, only: :update

  def create
    if @user
      @user.create_reset_digeset
      @user.send_password_reset_email
      render json: { message: 'パスワード再設定メールを送信しました。' }
    else
      response_not_found(:user)
    end
  end

  def update
    if params[:password].empty?
      render json: { error: true, message: 'パスワードが空です。' }, status: 400
    elsif @user.update_attributes(user_params)
      j_token = create_token_for_login(@user)
      @user.update_attribute(:reset_digest, nil)
      render json: { message: '新しいパスワードが設定されました。', token: j_token }
    else
      response_internal_server_error
    end
  end

  private

  def get_user
    @user = User.find_by(email: params[:email])
  end

  def user_params
    params.permit(:password, :password_confirmation)
  end

  def valid_user
    response_bad_request unless @user && @user.activated? && @user.authenticated?(:reset, params[:id])
  end

  def check_expiration
    response_unauthorized if @user.password_reset_expired?
  end

end
