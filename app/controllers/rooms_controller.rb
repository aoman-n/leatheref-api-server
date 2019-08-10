class RoomsController < ApplicationController
  before_action :authenticate!
  before_action :set_room, only: %i(show destroy leave)
  before_action :joined_user?, only: %i(show destroy leave)

  # 参考: https://moneyforward.com/engineers_blog/2019/04/02/activerecord-includes-preload-eagerload/
  # 参考: https://github.com/rails-api/active_model_serializers/blob/0-10-stable/docs/general/adapters.md#include-option
  def index
    rooms = current_user.rooms.eager_load(newest_message: :sender).preload(:users)
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
    if @room.destroy
      head :no_content
    else
      response_bad_request
    end
  end

  # /api/rooms/:id/join
  def join
    # あとからユーザーを追加したい場合の実装をする
  end

  def leave
    entry = current_user.entries.find_by(room_id: @room.id)
    if entry.present? && entry.destroy
      head :no_content
    else
      response_bad_request
    end
  end

  private

  def set_room
    @room = Room.find(params[:id])
    response_not_found if @room.blank?
  end

  def joined_user?
    unless @room.current_user_exists?(current_user)
      response_forbidden
    end
  end
end
