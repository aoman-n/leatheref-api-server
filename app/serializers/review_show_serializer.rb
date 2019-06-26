class ReviewShowSerializer
  include FastJsonapi::ObjectSerializer
  set_type :review
  set_id :id

  attributes :product_name, :content, :rating

  attribute :picture_path do |object|
    object.picture.url
  end

  attribute :comment_count do |object|
    object.without_reply_comments.count
  end

  attribute :store_name do |object|
    object.store_name
  end

  attribute :product_category_name do |object|
    object.product_category_name
  end

  has_many :without_reply_comments, key: :comments,
                                    record_type: :comment, serializer: CommentSerializer
end
