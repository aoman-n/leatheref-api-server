class Topic < ApplicationRecord
  belongs_to :community
  belongs_to :owner, class_name: "User"
  has_many :comeets, as: :comeetable

  validates :title, presence: true, length: { maximum: 50 }
end
