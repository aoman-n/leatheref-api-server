class DirectMessage < ApplicationRecord
  belongs_to :sender, class_name: "User"
  belongs_to :room

  validates :message, presence: true, length: { maximum: 400 }

  def owner?
    sender_id == current_user.id
  end
end
