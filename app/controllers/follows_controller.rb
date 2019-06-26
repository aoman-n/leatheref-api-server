class FollowsController < ApplicationController
  before_action :authenticate!, only: %i(create destroy)

  def create
    follows = current_user.active_follows.new(target_user_id: params[:id])
    if follows.save
      render status: :created
    else
      render json: { message: follows.errors.full_messages, type: 'Bad Request' }, status: 400
    end
  end

  def destroy
    follows = Follow.find_by(user_id: current_user.id, target_user_id: params[:id])
    if follows.destroy
      head :no_content
    else
      response_bad_request
    end
  end
end
