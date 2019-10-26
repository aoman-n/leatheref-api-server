class RenamePictureColumnToReviews < ActiveRecord::Migration[5.2]
  def change
    rename_column :reviews, :picture, :first_picture_url
  end
end
