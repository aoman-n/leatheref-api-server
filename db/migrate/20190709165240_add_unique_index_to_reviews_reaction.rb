class AddUniqueIndexToReviewsReaction < ActiveRecord::Migration[5.2]
  def change
    add_index :reviews_reactions, [:review_id, :reaction_id], unique: true
  end
end
