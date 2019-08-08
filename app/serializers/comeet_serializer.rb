class ComeetSerializer < ActiveModel::Serializer
  attributes :id, :message, :photo_path, :like_count
  belongs_to :user, serializer: UserSerializer
end
