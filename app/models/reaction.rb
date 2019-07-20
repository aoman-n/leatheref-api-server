class Reaction < ApplicationRecord
  has_many :review_reactions, dependent: :destroy
  has_many :reviews, through: :review_reactions

  validates :name, presence: true, uniqueness: true

  def self.serialize_counts(reaction_count_list)
    reaction_count_list.map do |r|
      {
        review_id: r.id,
        name: r.name,
        count: r.reaction_count,
        reacted: r.user_ids.split(',').map(&:to_i).include?(current_user&.id),
      }
    end
  end
end
