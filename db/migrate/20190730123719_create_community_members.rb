class CreateCommunityMembers < ActiveRecord::Migration[5.2]
  def change
    create_table :community_members do |t|
      t.references :user, foreign_key: true
      t.references :community, foreign_key: true

      t.timestamps
    end

    add_index :community_members, [:user_id, :community_id], unique: true
  end
end
