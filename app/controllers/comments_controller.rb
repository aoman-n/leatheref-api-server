class CommentsController < ApplicationController
  before_action :authenticate!, only: %i(create destroy update)
  before_action :set_review, only: %i(index create)
  before_action :set_comment, only: %i(replies destroy update)
  before_action :comment_owner?, only: %i(destroy update)

  def index
    comments = @review.without_reply_comments
    render json: comments
  end

  def replies
    replies = @comment.replies.order('created_at ASC')
    render json: replies
  end

  def create
    comment = @review.comments.new(comment_params)
    if comment.save
      render json: comment
    else
      render json: { message: @user.errors.full_messages, type: 'Bad Request' }, status: 400
    end
  end

  # 無駄にSQLが走っている気がする
  def destroy
    if @comment.destroy
      head :no_content
    else
      response_bad_request
    end
  end

  def update
    if @comment.update_attributes(comment: params[:comment])
      render json: @comment
    else
      render json: { message: @comment.errors.full_messages, type: 'Bad Request' }, status: 400
    end
  end

  private

  def comment_params
    params.permit(
      :comment,
      :reply,
      :in_reply_to_id,
    ).merge(user_id: current_user.id)
  end

  def set_review
    @review = Review.find_by(id: params[:review_id])
    if @review.nil?
      response_not_found('review')
    end
  end

  def set_comment
    @comment = Comment.find_by(id: params[:id])
    if @comment.nil?
      response_not_found('comment')
    end
  end

  def comment_owner?
    unless @current_user == @comment.user
      response_forbidden
    end
  end
end
