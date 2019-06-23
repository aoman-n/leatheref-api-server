class CreateComments < ActiveRecord::Migration[5.2]
  def change
    create_table :comments do |t|
      t.references :user, foreign_key: true
      t.references :review, foreign_key: true
      t.references :in_reply_to, foreign_key: { to_table: :comments }
      t.bigint :in_reply_to_id
      t.text :comment, null: false
      t.boolean :reply, default: false
      t.references :in_reply_to_user, foreign_key: { to_table: :users }
      t.integer :like_count, default: 0

      t.timestamps
    end
  end
end
