# == Schema Information
#
# Table name: users
#
#  id                :bigint           not null, primary key
#  email             :string(255)
#  name              :string(255)      not null
#  password_digest   :string(255)
#  remember_digest   :string(255)
#  admin             :boolean          default(FALSE)
#  activation_digest :string(255)
#  activated         :boolean          default(FALSE)
#  activated_at      :datetime
#  reset_digest      :string(255)
#  reset_sent_at     :datetime
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#  uid               :string(255)
#  provider          :string(255)
#  image_url         :string(255)
#

class User < ApplicationRecord
  # accessor
  attr_accessor :remember_token, :activation_token, :reset_token

  # callback
  before_create :create_activation_digest
  before_save :downcase_email
  before_save :set_display_name

  has_secure_password validations: false

  has_many :reviews
  has_many :likes, dependent: :destroy
  has_many :active_follows, class_name: "Follow",
                            foreign_key: "user_id",
                            dependent: :destroy
  has_many :passive_follows, class_name: "Follow",
                             foreign_key: "target_user_id",
                             dependent: :destroy

  validates :display_name, length: { maximum: 20 }
  VALID_LOGIN_NAME_REGEX = /[0-9A-Za-z]+/i
  validates :login_name, presence: true,
                         length: { maximum: 20 },
                         uniqueness: { case_sensitive: false },
                         format: { with: VALID_LOGIN_NAME_REGEX },
                         unless: :uid?
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i
  validates :email, presence: true,
                    length: { maximum: 250 },
                    format: { with: VALID_EMAIL_REGEX },
                    uniqueness: { case_sensitive: false },
                    unless: :uid?
  validates :password, presence: true,
                       length: { minimum: 6 },
                       allow_nil: true,
                       unless: :uid?

  def self.find_or_create_from_auth(auth)
    provider = auth[:provider]
    uid = auth[:uid]
    display_name = auth[:info][:name]
    login_name = auth[:info][:nickname]
    image = auth[:info][:image]
    find_or_create_by(provider: provider, uid: uid) do |user|
      user.display_name = display_name
      user.login_name = login_name
      user.image_url = image
    end
  end

  def self.digest(string)
    cost =
      if ActiveModel::SecurePassword.min_cost
        BCrypt::Engine::MIN_COST
      else
        BCrypt::Engine.cost
      end
    BCrypt::Password.create(string, cost: cost)
  end

  def self.new_token
    SecureRandom.urlsafe_base64
  end

  def remember
    self.remember_token = User.new_token
    update_attribute(:remember_digest, User.digest(remember_token))
  end

  def forget
    update_attribute(:remember_digest, nil)
  end

  def authenticated?(attribute, token)
    digest = send("#{attribute}_digest")
    return false if digest.nil?
    BCrypt::Password.new(digest).is_password?(token)
  end

  def send_activation_email
    UserMailer.account_activation(self).deliver_now
  end

  def create_activation_digest
    self.activation_token  = User.new_token
    self.activation_digest = User.digest(activation_token)
  end

  def activate
    update_columns(activated: true, activated_at: Time.zone.now)
  end

  def create_reset_digeset
    self.reset_token = User.new_token
    update_columns(reset_digest: User.digest(reset_token), reset_sent_at: Time.zone.now)
  end

  def send_password_reset_email
    UserMailer.password_reset(self).deliver_now
  end

  def password_reset_expired?
    reset_sent_at < 2.hours.ago
  end

  private

  def downcase_email
    email.downcase! if email.present?
  end

  def set_display_name
    self.display_name ||= login_name
  end
end
