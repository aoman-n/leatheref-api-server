class DirectMessagesController < ApplicationController
  before_action :authenticate!
  before_action :joined_user?

  def create
    direct_message = @room.direct_messages.new(message: params[:message],
                                               sender_id: current_user.id)
    if direct_message.save
      render json: direct_message
    else
      render json: { message: direct_message.errors.full_messages }, status: 400
    end
  end

  def destroy
    message = DirectMessage.find(params[:id])
    if message.owner?
      message.destroy
      head :no_content
    else
      response_forbidden
    end
  end

  private

  def joined_user?
    @room = Room.find(params[:room_id])
    unless room.current_user_exists?
      response_forbidden
    end
  end
end
