class ReactionsController < ApplicationController
  before_action :authenticate!, only: %i(create destroy)
  before_action :authenticate!, only: %i(create destroy)

  def create
    reaction = Reaction.find_by(name: params[:reaction_name])
    review_reaction = reaction.review_reactions.new(
      user_id: current_user.id,
      review_id: params[:review_id],
    )

    if review_reaction.save
      render status: :created
    else
      render json: {
        message: review_reaction.errors.full_messages,
        type: 'Bad Request',
      }, status: 400
    end
  end

  def destroy
    review_reaction = ReviewReaction
      .joins(:reaction)
      .find_by(
        user_id: current_user.id,
        review_id: params[:review_id],
        reactions: { name: params[:reaction_name] },
      )

    if review_reaction.destroy
      head :no_content
    else
      response_bad_request
    end
  end
end
