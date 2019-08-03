class CreateCommunityMembers < ActiveRecord::Migration[5.2]
  def change
    create_table :community_members do |t|
      t.references :member, foreign_key: { to_table: :users }
      t.references :community, foreign_key: true

      t.timestamps
    end

    add_index :community_members, [:member_id, :community_id], unique: true
  end
end
