class ReviewSerializer < ActiveModel::Serializer
  attributes :id, :product_name, :content, :picture_path, :created_at
  attribute :rating, key: :rara
  attribute :comment_count
  attribute :store_name
  attribute :product_category_name

  belongs_to :user, serializer: UserSerializer

  def picture_path
    object.picture.url
  end

  def comment_count
    object.comments.count
  end
end
