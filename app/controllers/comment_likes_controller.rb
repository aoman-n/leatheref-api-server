class CommentLikesController < ApplicationController
  before_action :authenticate!, only: %i(create destroy)

  def create
    like = Like.new(user_id: current_user.id, comment_id: params[:id])
    if like.save
      render status: :created
    else
      render json: { message: like.errors.full_messages, type: 'Bad Request' }, status: 400
    end
  end

  def destroy
    like = Like.find_by(user_id: current_user.id, comment_id: params[:id])
    if like.destroy
      head :no_content
    else
      response_bad_request
    end
  end
end
