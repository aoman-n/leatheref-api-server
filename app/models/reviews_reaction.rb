class ReviewsReaction < ApplicationRecord
  belongs_to :review
  belongs_to :reaction
end
