class CreateDirectMessages < ActiveRecord::Migration[5.2]
  def change
    create_table :direct_messages do |t|
      t.references :sender, foreign_key: { to_table: :users }
      t.references :room
      t.text :message, null: false
      t.string :image

      t.timestamps
    end
  end
end
