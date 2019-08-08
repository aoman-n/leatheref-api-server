class CommunityShowSerializer < ActiveModel::Serializer
  attributes :id, :title, :description, :symbol_image_path, :owner
  attributes :members_count

  belongs_to :owner, serializer: UserSerializer

  has_many :members, serializer: UserSerializer

  def members_count
    object.members.length
  end

  def symbol_image_path
    object.symbol_image&.url
  end
end
