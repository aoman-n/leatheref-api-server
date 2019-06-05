require 'jwt'

module SessionsHelper

  def log(string)
    puts string
  end

  def create_token_for_login(user)
    secret = ENV['HMAC_SECRET'] || 'hmac_jwt'
    user.remember
    payload = {
      user_id: user.id,
      token: user.remember_token
    }
    JWT.encode payload, secret, 'HS256'
  end

  def current_user
    return @current_user if @current_user.present?
    secret = ENV['HMAC_SECRET'] || 'hmac_jwt'
    return nil if request.headers['Authorization'].blank? or request.headers['Authorization'] !~ /\ABearer .*\z/
    token = request.headers['Authorization'].match(/\ABearer (.*)\z/)[1]
    decoded_token = JWT.decode(token, secret, true, { algorithm: 'HS256' }).first
    user = User.find_by(id: decoded_token['user_id'])
    if user && user.activated? && user.authenticated?(:remember, decoded_token['token'])
      @current_user = user
    else
      nil
    end
  end

  def logged_in?
    !current_user.nil?
  end

  def log_out
    current_user.forget
    @current_user = nil
  end

  # 渡されたユーザーがログイン済みユーザーであればtrueを返す
  # def current_user?(user)
  #   user == current_user
  # end

end