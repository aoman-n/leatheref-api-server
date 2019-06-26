class CommentSerializer
  include FastJsonapi::ObjectSerializer
  set_type :comment
  set_id :id

  attributes :comment, :like_count, :created_at

  attribute :reply_count do |object|
    object.replies.count
  end

  attribute :liked do |object, params|
    current_user = params[:current_user]
    if current_user
      object.likes.exists?(user_id: current_user.id)
    else
      false
    end
  end
end
