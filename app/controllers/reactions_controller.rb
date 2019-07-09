class ReactionsController < ApplicationController
  before_action :authenticate!, only: %i(create destroy)

  def create
    reaction = Reaction.find_by(name: params[:reaction_name])
    reviews_reaction = ReviewsReaction.new(review_id: params[:review_id], reaction_id: reaction.id)
    if reviews_reaction.save
      render status: :created
    else
      render json: {
        message: reviews_reaction.errors.full_messages,
        type: 'Bad Request',
      }, status: 400
    end
  end

  def destroy
    reviews_reaction = ReviewsReaction
      .joins(:reaction)
      .find_by(
        review_id: params[:review_id],
        reactions: { name: params[:reaction_name] },
      )

    if reviews_reaction.destroy
      head :no_content
    else
      response_bad_request
    end
  end
end
