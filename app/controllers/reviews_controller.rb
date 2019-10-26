class ReviewsController < ApplicationController
  before_action :authenticate!, only: %i(create destroy)
  before_action :set_review, only: %i(update destroy)
  before_action :review_owner?, only: %i(update destroy)

  def index
    filtering_list = Review.get_filtering_list(params)
    initialized_reviews = paginate Review.base_active_record(page: params[:page],
                                                             per_page: params[:per_page])
    reviews = filtering_list
      .reduce(initialized_reviews) do |r, (key, val)|
        r.send("#{key}_with", val)
      end
      .eager_load(:user, :store, :product_category)

    # reviewに対するそれぞれのreactionをカウントする
    serialized_reaction_count_list = Reaction.serialize_counts(Review.reaction_counts(reviews.map(&:id)))

    render json: ActiveModel::Serializer::CollectionSerializer.new(
      reviews,
      serializer: ReviewSerializer,
      current_user: current_user,
      serialized_reaction_count_list: serialized_reaction_count_list,
      include: ['user', 'store', 'product_category']
    )
  end

  # TODO: N+1を解決する
  def show
    review = Review.includes(comments: :user).find(params[:id])
    if review.nil?
      response_not_found('review')
    end

    render json: review, serializer: ReviewShowSerializer,
           include: '**',
           scope: {
             'current_user': current_user,
           }
  end

  def create
    review = Review.new(review_params)
    if review.save
      render json: review, serializer: ReviewShowSerializer, include: '**', status: 201
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
