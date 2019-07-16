require 'jwt'

class DecodeToken
  attr_accessor :decoded_token

  SECRET = ENV['HMAC_SECRET'] || 'hmac_jwt'

  def initialize(token)
    @decoded_token = DecodeToken.decode(token)
  end

  def self.decode(token)
    JWT.decode(token, SECRET, true, algorithm: 'HS256').first
  end

  def valid_user?(user)
    activated?(user) && authenticated?(user)
  end

  def get_user
    User.find_by(id: decoded_token['user_id'])
  end

  private

  def activated?(user)
    user.activated?
  end

  def authenticated?(user)
    user.authenticated?(:remember, decoded_token['token'])
  end
end
