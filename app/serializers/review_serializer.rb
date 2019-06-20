class ReviewSerializer < ActiveModel::Serializer
  attributes :id, :product_name, :content, :picture_path
  attribute :rating, key: :rara

  belongs_to :user, serializer: UserSerializer
  belongs_to :store
  belongs_to :product_category

  def picture_path
    object.picture.url
  end

  class StoreSerializer < ActiveModel::Serializer
    attributes :name, :id
  end

  class ProductCategorySerializer < ActiveModel::Serializer
    attributes :name
  end
end
