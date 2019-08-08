class CommunityComeetsController < ApplicationController
  before_action :authenticate!
  before_action :set_community, only: %i(show create)
  before_action :set_comeet, only: %i(show destroy update)
  before_action :require_community_member, only: %i(create)
  before_action :comeet_owner?, only: %i(destroy update)

  def index
    comeets = paginate Comeet.paginate(page: params[:page], per_page: params[:perpage])
      .filter_community_id(params[:community_id])
      .recent.eager_load(:user)
    render json: comeets, each_serializer: ComeetSerializer, include: ['user']
  end

  def create
    comeet = @community.comeets.new(comeet_params)
    if comeet.save
      render json: comeet
    else
      response_bad_request(comeet.errors.full_messages)
    end
  end

  def show
    render json: @comeet
  end

  def destroy
    if @comeet.destroy
      head :no_content
    else
      response_bad_request
    end
  end

  def update
    if @comeet.update(comeet_params)
      render json: @comeet
    else
      response_bad_request(@comeet.errors.full_messages)
    end
  end

  private

  def set_community
    @community = Community.find_by(id: params[:community_id])
    response_not_found('community') if @community.nil?
  end

  def require_community_member
    response_forbidden unless @community.member?(current_user)
  end

  def set_comeet
    @comeet = Comeet.find_by(id: params[:id])
    response_not_found('comeet') if @comeet.nil?
  end

  def comeet_owner?
    response_forbidden unless @comeet.user_id == current_user.id
  end

  def comeet_params
    params.permit(:message, :photo).merge(user_id: current_user.id)
  end
end
