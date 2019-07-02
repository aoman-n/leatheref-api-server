class DirectMessageSerializer < ActiveModel::Serializer
  attributes :id, :updated_at
  attribute :image_url, if: -> { object.image? }
  attribute :message, if: -> { object.message? }
  belongs_to :sender

  def image_url
    object.image.url
  end

  class UserSerializer < ActiveModel::Serializer
    attributes :id, :display_name, :login_name, :image_url
  end
end
