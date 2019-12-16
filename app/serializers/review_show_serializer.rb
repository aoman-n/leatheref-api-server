class ReviewShowSerializer < ActiveModel::Serializer
  attributes :id, :product_name, :content, :picture_path, :rating, :created_at, :price
  attribute :store_name
  attribute :product_category_name

  belongs_to :user, serializer: UserSerializer
  # has_many :without_reply_comments, key: :comments

  def picture_path
    object.review_pictures.map { |p| p.picture.url }
  end

  # class CommentSerializer < ActiveModel::Serializer
  #   attributes :id, :comment, :like_count, :created_at
  #   attribute :reply_count
  #   attribute :liked
  #   belongs_to :user

  #   def reply_count
  #     object.replies.count
  #   end

  #   def liked
  #     current_user = scope[:current_user]
  #     if current_user
  #       object.likes.exists?(user_id: current_user.id)
  #     else
  #       false
  #     end
  #   end
  # end
end
