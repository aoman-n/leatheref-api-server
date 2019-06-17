class Store < ApplicationRecord
  validates :name, uniqueness: true, presence: true
end
