class RoomSerializer < ActiveModel::Serializer
  attributes :id, :name
  has_many :users
  has_one :newest_message, serializer: NewestDirectMessageSerializer
end
