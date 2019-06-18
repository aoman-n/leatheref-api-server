class ReviewsController < ApplicationController
  before_action :authenticate!, only: %i(create destroy)
  before_action :set_review, only: %i(show update destroy)

  def index
    reviews = Review.recent
    render json: { reviews: reviews }
  end

  def show
    render json: @review
  end

  def create
    review = Review.new(review_params)
    if review.save
      render json: review
    else
      response_bad_request
    end
  end

  def update
    if @review.update_attributes(review_params)
      render json: @review
    else
      response_bad_request
    end
  end

  def destroy
    if @review.destroy
      render json: { message: 'deleted' }
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
end
