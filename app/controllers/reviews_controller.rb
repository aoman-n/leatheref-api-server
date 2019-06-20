class ReviewsController < ApplicationController
  before_action :authenticate!, only: %i(create destroy)
  before_action :set_review, only: %i(show update destroy)
  before_action :review_owner?, only: %i(update destroy)

  def index
    per_page = params[:per_page] ||= 10
    reviews = paginate Review.page(params[:page] ||= 1).per(per_page).recent
    render json: reviews
  end

  def show
    render json: @review
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