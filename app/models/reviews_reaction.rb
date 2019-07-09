class ReviewsReaction < ApplicationRecord
  belongs_to :review
  belongs_to :reaction

  validates :review_id, uniqueness: { scope: :reaction_id }
end
