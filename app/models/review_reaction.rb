class ReviewReaction < ApplicationRecord
  belongs_to :review
  belongs_to :reaction
  belongs_to :user

  validates :review_id, uniqueness: {
    scope: [:reaction_id, :user_id],
    message: '同レビューに対し同リアクションは一つのみ付けられます。',
  }
end
