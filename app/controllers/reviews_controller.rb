class ReviewsController < ApplicationController
  before_action :authenticate!, only: %i(create destroy)
  before_action :set_review, only: %i(show update destroy)
  before_action :review_owner?, only: %i(update destroy)

  def index
    per_page = params[:per_page] ||= 10
    page = params[:page] ||= 1
    # TODO: リファクタリング
    # モデルクラスの特異メソッドに移動する(filtering_list, initialized_reviews)
    filtering_list = params.permit!.slice(:store, :category).to_hash.compact

    initialized_reviews = paginate Review
      .page(page)
      .per(per_page)
      .recent

    reviews = filtering_list
      .reduce(initialized_reviews) do |r, (key, val)|
        r.send("#{key}_with", val)
      end
      .eager_load(:user, :store, :product_category)

    # reviewに対するそれぞれのreactionをカウントする
    reaction_counts = Review
      .where(id: reviews.map(&:id))
      .joins(:reactions)
      .group("name, id")
      .select("reviews.*, reactions.name, COUNT(reviews.id) AS reaction_count, GROUP_CONCAT(review_reactions.user_id separator ',') AS user_ids")
      .map { |r| { review_id: r.id, name: r.name, count: r.reaction_count, reacted: r.user_ids.split(',').map(&:to_i).include?(current_user&.id) } }

    render json: ActiveModel::Serializer::CollectionSerializer.new(
      reviews,
      serializer: ReviewSerializer,
      current_user: current_user,
      reaction_counts: reaction_counts,
      include: ['user', 'store', 'product_category']
    )
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
