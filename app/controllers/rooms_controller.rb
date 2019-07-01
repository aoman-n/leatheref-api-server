class RoomsController < ApplicationController
  before_action :authenticate!
  before_action :set_room, only: %i(show destroy)
  before_action :joined_user?, only: %i(show destroy)

  def index
    # TODO: queryを無駄に発行しているため、最小限に抑える書き方を調べる。
    rooms = current_user.rooms.includes(:newest_message, :users, { newest_message: :sender })
    # includeでネストに対応 -> 参考: https://github.com/rails-api/active_model_serializers/blob/0-10-stable/docs/general/adapters.md#include-option
    render json: rooms, each_serializer: RoomSerializer,
           include: ['newst_message', 'users', 'newest_message.sender']
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
