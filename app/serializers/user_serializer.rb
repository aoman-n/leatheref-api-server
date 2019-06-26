class UserSerializer < ActiveModel::Serializer
  attributes :id, :display_name, :image_url
end
