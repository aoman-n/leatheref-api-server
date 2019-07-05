class ReviewsController < ApplicationController
  before_action :authenticate!, only: %i(create destroy)
  before_action :set_review, only: %i(show update destroy)
  before_action :review_owner?, only: %i(update destroy)

  def index
    per_page = params[:per_page] ||= 10
    page = params[:page] ||= 1
    filtering_list = params.permit!.slice(:store, :category).to_hash.compact

    # TODO: リファクタリング
    initialized_reviews = paginate Review
      .page(page)
      .per(per_page)
      .recent
    reviews = filtering_list
      .reduce(initialized_reviews) do |r, (key, val)|
        r.send("#{key}_with", val)
      end
      .includes(:user, :store, :product_category)

    render json: ActiveModel::Serializer::CollectionSerializer.new(
      reviews,
      serializer: ReviewSerializer,
      current_user: current_user,
    )

    # per_page = params[:per_page] ||= 10
    # reviews = paginate Review.page(params[:page] ||= 1)
    #   .per(per_page)
    #   .with_store?(params[:store])
    #   .with_category?(params[:category]).recent
    #   .includes(:user, :store, :product_category)

    # render json: reviews, each_serializer: ReviewSerializer, scope: {
    #   'current_user': current_user,
    # }
  end

  def show
    render json: @review, serializer: ReviewShowSerializer, scope: {
      'current_user': current_user,
    }
  end

  def create
    review = Review.new(review_params)
    if review.save
      render json: review, status: 201
    else
      response_bad_request
    end
  end

  def update
    if @review.update_attributes(review_params)
      render json: @review, status: 204
    else
      response_bad_request
    end
  end

  def destroy
    if @review.destroy
      render json: { message: 'deleted' }, status: 204
    else
      response_bad_request
    end
  end

  private

  def review_params
    params.permit(
      :product_name,
      :content,
      :picture,
      :price,
      :rating,
      :store_id,
      :product_category_id,
    ).merge(user_id: current_user.id)
  end

  def set_review
    @review = Review.find_by(id: params[:id])
    if @review.nil?
      response_not_found('review')
    end
  end

  def review_owner?
    unless current_user == @review.user
      response_forbidden
    end
  end
end
