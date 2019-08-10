class CommunitiesController < ApplicationController
  before_action :authenticate!, except: :index
  before_action :set_community, except: %i(index create)
  before_action :community_member?, only: %i(show leave)
  before_action :community_owner?, only: %i(update destroy)

  def index
    communities = paginate Community.fetch_list(page: params[:page],
                                                per_page: params[:per_page])
    render json: communities, each_serializer: CommunitySerializer, include: ['members']
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
    @community = Community.find_by(id: params[:id])
    response_not_found('Community') if @community.nil?
    render json: @community, serializer: CommunityShowSerializer
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

  def join
    response_forbidden and return if @community.approval?

    community_member = @community.community_members.new(member_id: current_user.id)
    if community_member.save
      render json: { message: '参加しました' }
    else
      response_bad_request(community_member.errors.full_messages)
    end
  end

  def leave
    community_member = CommunityMember.find_by(member_id: current_user.id, community_id: @community.id)
    if community_member.destroy
      head :no_content
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

  def set_community
    @community = Community.find_by(id: params[:id])
    response_not_found('Community') if @community.nil?
  end

  def community_member?
    if @community.approval? && !@community.member?(current_user)
      response_forbidden
    end
  end

  def community_owner?
    unless current_user == @community.owner
      response_forbidden
    end
  end
end
