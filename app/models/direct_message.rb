class DirectMessage < ApplicationRecord
  belongs_to :sender, class_name: "User"
  belongs_to :room

  validates :message, presence: true, length: { maximum: 400 }, unless: :image?
  validates :image, presence: true, unless: :message?

  enum data_type: { message: 0, image: 1 }

  scope :recent, -> { order(created_at: :desc) }

  def owner?
    sender_id == current_user.id
  end
end
