class JoinRequest < ApplicationRecord
  belongs_to :user
  belongs_to :community

  validates :message, presence: true, length: { maximum: 300 }
  validates :status, presence: true

  enum status: { unchecked: 0, accept: 1, reject: 2 }, _prefix: true
end
