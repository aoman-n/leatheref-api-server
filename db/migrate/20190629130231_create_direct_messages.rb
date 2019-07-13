class CreateDirectMessages < ActiveRecord::Migration[5.2]
  def change
    create_table :direct_messages do |t|
      t.references :sender, foreign_key: { to_table: :users }
      t.references :room, foreign_key: true
      t.text :message
      t.string :image
      t.integer :data_type

      t.timestamps
    end
  end
end
