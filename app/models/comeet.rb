class Comeet < ApplicationRecord
  belongs_to :comeetable, polymorphic: true
  belongs_to :user

  validates :message, presence: true, length: { maximum: 500 }
  mount_uploader :photo, ComeetPhotoUploader

  scope :recent, -> { order(created_at: :desc) }
  scope :filter_community_id, -> (id) {
    where(comeetable_id: id)
  }

  def photo_path
    photo&.url
  end
end
