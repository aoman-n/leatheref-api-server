class CreateReactions < ActiveRecord::Migration[5.2]
  def change
    create_table :reactions do |t|
      t.string :name, null: false

      t.timestamps
    end
    add_index :reactions, :name, unique: true
  end
end
