class CreateFollows < ActiveRecord::Migration[5.2]
  def change
    create_table :follows do |t|
      t.references :user, foreign_key: true
      t.references :target_user, foreign_key: { to_table: :users }

      t.timestamps
    end
    add_index :follows, [:user_id, :target_user_id], unique: true
  end
end
