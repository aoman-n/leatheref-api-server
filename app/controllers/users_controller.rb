class UsersController < ApplicationController
  before_action :authenticate!, only: [:me]

  def create
    @user = User.new(user_params)
    if @user.save
      @user.send_activation_email
      render json: { message: '確認メールを送信しました。' }
    else
      render json: { errors: @user.errors.full_messages }, status: 401
    end
  end

  def me
    render json: current_user
  end

  private

  def user_params
    params.permit(:login_name, :email, :password, :password_confirmation)
  end
end
