class CreateJoinRequests < ActiveRecord::Migration[5.2]
  def change
    create_table :join_requests do |t|
      t.references :user, foreign_key: true, null: false
      t.references :community, foreign_key: true, null: false
      t.text :message, null: false
      t.integer :status, default: 0

      t.timestamps
    end
  end
end
