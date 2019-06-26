class ReviewSerializer
  include FastJsonapi::ObjectSerializer
  set_type :review
  set_id :id

  attributes :product_name, :content

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

  belongs_to :user, serializer: UserSerializer
end
