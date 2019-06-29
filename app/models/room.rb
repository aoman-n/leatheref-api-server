class Room < ApplicationRecord
  has_many :entries, dependent: :destroy
  has_many :users, through: :entries
  has_many :direct_messages, dependent: :destroy

  def current_user_exists?
    entries.exists?(user_id: current_user.id)
  end
end
