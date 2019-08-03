class Community < ApplicationRecord
  has_many :community_members
  has_many :members, class_name: "User", through: :community_members
  belongs_to :owner, class_name: "User"

  mount_uploader :symbol_image, SymbolImageUploader

  validates :title, presence: true,
                    length: { maximum: 30 },
                    uniqueness: { case_sensitive: false }
  validates :description, presence: true,
                          length: { maximum: 300 }

  enum permittion_level: { anyone: 0, approval: 1 }

  scope :recent, -> { order(updated_at: :desc) }

  MAX_PER_PAGE = 30
  DEFAULT_PER_PAGE = 10

  def self.fetch_list(args = {})
    page = args[:page] || 1
    per_page = args[:per_page] || DEFAULT_PER_PAGE
    per_page = MAX_PER_PAGE if per_page > MAX_PER_PAGE
    Community.page(page).per(per_page).recent.eager_load(:owner).preload(:members)
  end
end
