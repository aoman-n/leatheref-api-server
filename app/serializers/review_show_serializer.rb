class ReviewShowSerializer < ActiveModel::Serializer
  attributes :id, :product_name, :content, :picture_path, :rating
  # attribute :comments, unless: :reply?

  belongs_to :user, serializer: UserSerializer
  belongs_to :store, serializer: StoreSerializer
  belongs_to :product_category, serializer: ProductCategorySerializer
  has_many :without_reply_comments, key: :comments

  def picture_path
    object.picture.url
  end

  class CommentSerializer < ActiveModel::Serializer
    attributes :id, :comment, :like_count, :created_at
    attribute :reply_count
    attribute :liked

    def reply_count
      object.replies.count
    end

    def liked
      current_user = scope[:current_user]
      if current_user
        object.likes.exists?(user_id: current_user.id)
      else
        false
      end
    end
  end
end
