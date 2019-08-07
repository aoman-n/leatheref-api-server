class Topic < ApplicationRecord
  belongs_to :community
  belongs_to :owner, class_name: "User"

  validates :title, presence: true, length: { maximum: 50 }
end
