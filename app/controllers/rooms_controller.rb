class RoomsController < ApplicationController
  before_action :authenticate!
  before_action :set_room, only: %i(show destroy)
  before_action :joined_user?, only: %i(show destroy)

  def index
    rooms = current_user.rooms
    render json: rooms
  end

  def show
    room = Room.find(params[:id])
    messages = room.direct_messages
    render json: messages
  end

  def create
    user_ids = [current_user.id].concat(JSON.parse(params[:user_ids]) || []).uniq
    room = Room.new({ user_ids: user_ids })
    if room.save
      render json: room
    else
      response_bad_request
    end
  end

  def destroy
    room = Room.find(params[:id])
    if room.destroy
      head :no_content
    else
      response_bad_request
    end
  end

  private

  def set_room
    @room = Room.find(params[:id])
  end

  def joined_user?
    unless @room.current_user_exists?
      response_forbidden
    end
  end
end
