class CreateCommunities < ActiveRecord::Migration[5.2]
  def change
    create_table :communities do |t|
      t.string :title, null: false
      t.text :description, null: false
      t.integer :permittion_level, default: 0
      t.string :symbol_image
      t.references :owner, foreign_key: { to_table: :users }

      t.timestamps
    end

    add_index :communities, :title, unique: true
  end
end
