class ReviewSerializer < ActiveModel::Serializer
  attributes :id, :product_name, :content, :picture_path
  attribute :rating, key: :rara

  belongs_to :user, serializer: UserSerializer
  belongs_to :store, serializer: StoreSerializer
  belongs_to :product_category, serializer: ProductCategorySerializer

  def picture_path
    object.picture.url
  end
end
