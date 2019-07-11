class AddUniqueIndexToReviewReaction < ActiveRecord::Migration[5.2]
  def change
    add_index :review_reactions, [:review_id, :reaction_id, :user_id], unique: true
  end
end
