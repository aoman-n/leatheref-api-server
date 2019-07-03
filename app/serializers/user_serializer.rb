# == Schema Information
#
# Table name: users
#
#  id                :bigint           not null, primary key
#  email             :string(255)
#  display_name      :string(255)
#  login_name        :string(255)      not null
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

class UserSerializer < ActiveModel::Serializer
  attributes :id, :display_name, :login_name, :image_url
end
