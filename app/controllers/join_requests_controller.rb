class JoinRequestsController < ApplicationController
  before_action :authenticate!
  before_action :set_community
  before_action :require_community_owner, except: :create
  before_action :set_join_request, only: %i(show accept reject)

  def index
    join_requests = paginate JoinRequest.paginate(paginte_params)
      .filter_status(status_params)
      .filter_community(@community.id)
      .eager_load(:user)
    render json: join_requests
  end

  def show
    render json: @join_request
  end

  def create
    puts '---------------create'
    p params
    join_request = JoinRequest.new(join_request_params)
    if join_request.save
      render json: join_request, status: 201
    else
      response_bad_request(join_request.errors.full_messages)
    end
  end

  def accept
    if @join_request.status == 'unchecked'
      ActiveRecord::Base.transaction do
        @join_request.update!(status: 'accept')
        CommunityMember.create!(community_id: @community.id, member_id: @join_request.user.id)
      end
      render json: { message: '承認しました' }
    else
      render json: { message: '確認済みのリクエストです。' }, status: 405
    end
  end

  def reject
    if @join_request.status == 'unchecked'
      if @join_request.update(status: 'reject')
        render json: { message: '拒否しました' }
      else
        response_bad_request
      end
    else
      render json: { message: '確認済みのリクエストです。' }, status: 405
    end
  end

  private

  def join_request_params
    params.permit(:message).merge(user_id: current_user.id, community_id: @community.id)
  end

  def set_community
    @community = Community.find_by(id: params[:community_id])
    response_not_found('join request') if @community.nil?
  end

  def set_join_request
    @join_request = JoinRequest.find_by(id: params[:id])
  end

  def require_community_owner
    unless current_user == @community.owner
      response_forbidden
    end
  end

  def paginte_params
    { per_page: params[:per_page], page: params[:page] }
  end

  def status_params
    params[:status] || 'unchecked'
  end
end
