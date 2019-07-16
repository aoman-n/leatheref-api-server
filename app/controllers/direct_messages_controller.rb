class DirectMessagesController < ApplicationController
  before_action :authenticate!
  before_action :joined_user?

  def create
    data_type = params[:data_type]
    case data_type
    when 'message'
      message_params = params_with_message
    when 'image'
      message_params = params_with_image
    else
      response_bad_request and return
    end

    direct_message = @room.direct_messages.new(message_params)
    if direct_message.save
      render json: direct_message
    else
      render json: { message: direct_message.errors.full_messages }, status: 400
    end
  end

  def destroy
    message = DirectMessage.find(params[:id])
    if message.owner?
      message.destroy!
      head :no_content
    else
      response_forbidden
    end
  end

  private

  def joined_user?
    @room = Room.find(params[:room_id])
    unless @room.current_user_exists?(current_user)
      response_forbidden
    end
  end

  def params_with_message
    params.permit(:message).merge(sender_id: current_user.id, data_type: DirectMessage.data_types['message'])
  end

  def params_with_image
    params.permit(:image).merge(sender_id: current_user.id, data_type: DirectMessage.data_types['image'])
  end
end
