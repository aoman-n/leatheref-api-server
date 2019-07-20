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

  # PATCH /api/users/:id MEMO: 「:id」は使用してないためurlにも必要ないかも
  # TODO: 修正
  # user情報をupdateするときに、コールバックでimage_urlを更新するとよさそう。トランザクション内でimage_urlをアップデートさせるため。
  # image_urlを更新するかどうか(コールバックを実行するか)は、imageカラムが変更されたかどうかで分岐させる。
  # もしくは、transactionで囲んでupdateするか。
  def update
    current_user.update!(update_user_params)
    current_user.update!(image_url: current_user.image.url)
    render current_user
  rescue => e
    p e
    logger.error e.message
    logger.error e.backtrace.join("\n")
    render json: { message: current_user.errors.full_messages }, status: 400
  end

  def me
    render json: current_user
  end

  def following
    user = User.find(params[:id])
    users = paginate user.following.page(params[:page] ||= 1).per(params[:per_page] ||= 10)
    render json: users, each_serializer: UserSerializer
  end

  def followers
    user = User.find(params[:id])
    users = paginate user.followers.page(params[:page] ||= 1).per(params[:per_page] ||= 10)
    render json: users, each_serializer: UserSerializer
  end

  def search
    limit_page = 30
    q = params[:q]
    page = params[:page]
    per_page = (page.to_i > limit_page || page.blank?) ? 10 : page
    users = User.where(['login_name LIKE ?', "%#{q}%"]).limit(per_page)
    render json: users, each_serializer: UserSerializer
  end

  private

  def user_params
    params.permit(:login_name, :email, :password, :password_confirmation)
  end

  def update_user_params
    params.permit(:login_name, :display_name, :image, :love_store_id)
  end
end
