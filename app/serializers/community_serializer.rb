class CommunitySerializer < ActiveModel::Serializer
  attributes :id, :title, :description, :symbol_image_path
  attributes :members_count

  belongs_to :owner, serializer: UserSerializer

  # memberの情報を取得したくなったら
  # has_many :users

  def members_count
    object.users.length
  end

  def symbol_image_path
    object.symbol_image&.url
  end
end
