class CommentSerializer < ActiveModel::Serializer
  attributes :id, :comment, :like_count, :created_at
  # attribute :reply_count
  attribute :liked
  belongs_to :user

  # 一旦リプライ機能は使わない
  # def reply_count
  #   object.replies.count
  # end

  def liked
    current_user = scope[:current_user]
    if current_user.nil?
      false
    else
      object.likes.exists?(user_id: current_user.id)
    end
  end
end
