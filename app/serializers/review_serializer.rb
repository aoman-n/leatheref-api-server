class ReviewSerializer < ActiveModel::Serializer
  attributes :id, :product_name, :content, :picture_path
  attribute :rating, key: :rara
  # attribute :comments, unless: :reply?

  belongs_to :user, serializer: UserSerializer
  belongs_to :store, serializer: StoreSerializer
  belongs_to :product_category, serializer: ProductCategorySerializer
  has_many :comments

  def picture_path
    object.picture.url
  end

  class CommentSerializer < ActiveModel::Serializer
    attributes :id, :comment, :like_count, :created_at
    attribute :reply_count

    def reply_count
      object.replies.count
    end
  end
end
