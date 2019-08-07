class Comeet < ApplicationRecord
  belongs_to :comeetable, polymorphic: true
  belongs_to :user

  validates :message, presence: true, length: { maximum: 500 }
  mount_uploader :photo, ComeetPhotoUploader
end
