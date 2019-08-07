class CreateComeets < ActiveRecord::Migration[5.2]
  def change
    create_table :comeets do |t|
      t.text :message, null: false
      t.string :photo
      t.integer :like_count, default: 0
      t.references :user, foreign_key: true
      t.references :comeetable, polymorphic: true, index: true

      t.timestamps
    end
  end
end
