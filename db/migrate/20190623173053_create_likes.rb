class CreateLikes < ActiveRecord::Migration[5.2]
  def change
    create_table :likes do |t|
      t.references :user, foreign_key: true, index: false, null: false
      t.references :comment, foreign_key: true, index: false, null: false

      t.timestamps
    end
    add_index :likes, [:user_id, :comment_id], unique: true
  end
end
