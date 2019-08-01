class CommunitiesController < ApplicationController
  before_action :authenticate!, except: :index
  before_action :community_member?, only: :show
  before_action :set_community, except: %i(index create)
  before_action :community_owner?, only: %i(update destroy)

  def index
    communities = Community.recent
    render json: communities
  end

  def create
    community = Community.new(community_params)
    if community.save
      render json: community, status: 201
    else
      response_bad_request(community.errors.full_messages)
    end
  end

  def show
    # implement
  end

  def update
    if @community.update_attributes(community_params)
      render json: @community
    else
      response_bad_request(@community.errors.full_messages)
    end
  end

  def destroy
    if @community.destroy
      response_deleted
    else
      response_bad_request
    end
  end

  private

  def community_params
    params.permit(
      :title,
      :description,
      :permittion_level,
      :symbol_image,
    ).merge(owner_id: current_user.id)
  end

  def community_member?
    # implement
  end

  def set_community
    @community = Community.find_by(id: params[:id])
    response_not_found('Community') if @community.nil?
  end

  def community_owner?
    unless current_user == @community.owner
      response_forbidden
    end
  end
end
