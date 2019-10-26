class CreateReviewPictures < ActiveRecord::Migration[5.2]
  def change
    create_table :review_pictures do |t|
      t.references :review, foreign_key: { on_delete: :cascade }
      t.string :picture, null: false

      t.timestamps
    end
  end
end
