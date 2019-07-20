class AddLoveStoreIdColumnToUser < ActiveRecord::Migration[5.2]
  def change
    add_reference :users, :love_store, foreign_key: { to_table: :stores }
  end
end
