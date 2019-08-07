class CreateTopics < ActiveRecord::Migration[5.2]
  def change
    create_table :topics do |t|
      t.string :title, null: false
      t.references :community, foreign_key: true
      t.references :owner, foreign_key: { to_table: :users }

      t.timestamps
    end
  end
end
