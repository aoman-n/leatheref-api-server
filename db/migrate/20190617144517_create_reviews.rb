class CreateReviews < ActiveRecord::Migration[5.2]
  def change
    create_table :reviews do |t|
      t.string :product_name, null: false
      t.text :content, null: false
      t.string :picture
      t.integer :price
      t.integer :rating, null: false
      t.integer :comment_count, default: 0
      t.references :user, foreign_key: true
      t.references :store, foreign_key: true

      t.timestamps
    end
  end
end
