class DirectMessage < ApplicationRecord
  belongs_to :sender, class_name: "User"
  belongs_to :room

  after_create_commit :broadcast_web_nofitication

  validates :message, presence: true, length: { maximum: 400 }, unless: :image?
  validates :image, presence: true, unless: :message?

  enum data_type: { message: 0, image: 1 }
  mount_uploader :image, DirectMessageImageUploader

  scope :recent, -> { order(created_at: :desc) }

  def owner?
    sender_id == current_user.id
  end

  private

  def broadcast_web_nofitication
    DirectMessageNotificationBroadcastJob.perform_later(room.users.ids)
  end
end
