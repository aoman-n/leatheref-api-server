class DirectMessage < ApplicationRecord
  belongs_to :sender, class_name: "User"
  belongs_to :room

  validates :message, presence: true, length: { maxmum: 400 }
end
