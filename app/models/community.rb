class Community < ApplicationRecord
  has_many :community_members
  has_many :users, through: :community_members
  belongs_to :owner, class_name: "User"

  mount_uploader :symbol_image, SymbolImageUploader

  validates :title, presence: true,
                    length: { maximum: 30 },
                    uniqueness: { case_sensitive: false }
  validates :description, presence: true,
                          length: { maximum: 300 }

  enum permittion_level: { anyone: 0, approval: 1 }

  scope :recent, -> { order(updated_at: :desc) }
end
