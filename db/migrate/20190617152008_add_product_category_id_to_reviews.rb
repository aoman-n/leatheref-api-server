class AddProductCategoryIdToReviews < ActiveRecord::Migration[5.2]
  def change
    add_reference :reviews, :product_category, foreign_key: true
  end
end
