class Room < ApplicationRecord
  has_many :users
  has_many :direct_messages
end
