class Reaction < ApplicationRecord
  has_many :review_reactions, dependent: :destroy
  has_many :reviews, through: :review_reactions

  validates :name, presence: true, uniqueness: true
end
