class BroadcastReviewSerializer < ActiveModel::Serializer
  attributes :id, :product_name, :content, :comment_count, :picture_path, :created_at
  attribute :rating
  attribute :store_name
  attribute :product_category_name
  attribute :reactions

  belongs_to :user, serializer: UserSerializer

  def picture_path
    object.picture.url
  end

  # 新規レビューなので空になる
  def reactions
    []
  end
end
