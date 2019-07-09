class Reaction < ApplicationRecord
  has_many :reviews_reactions, dependent: :destroy
  has_many :reviews, through: :reviews_reactions

  validates :name, presence: true
end
