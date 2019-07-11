class CreateReviewReactions < ActiveRecord::Migration[5.2]
  def change
    create_table :review_reactions do |t|
      t.references :review, foreign_key: true
      t.references :reaction, foreign_key: true
      t.references :user, foreign_key: true

      t.timestamps
    end
  end
end
