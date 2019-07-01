class NewestDirectMessageSerializer < ActiveModel::Serializer
  attributes :id, :image, :message, :updated_at
  belongs_to :sender

  class UserSerializer < ActiveModel::Serializer
    attributes :id, :display_name, :login_name, :image_url
  end
end
