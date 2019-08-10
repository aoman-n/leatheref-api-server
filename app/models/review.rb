class Review < ApplicationRecord
  belongs_to :user
  belongs_to :store
  belongs_to :product_category
  has_many :comments, dependent: :destroy
  has_many :without_reply_comments, -> { where 'reply = false' },
           class_name: 'Comment', dependent: :destroy
  has_many :review_reactions, dependent: :destroy
  has_many :reactions, through: :review_reactions

  after_create_commit :broadcast_new_review

  mount_uploader :picture, PictureUploader

  delegate :name, to: :store, prefix: true
  delegate :name, to: :product_category, prefix: true

  validates :product_name, presence: true, length: { minimum: 4 }
  validates :content, presence: true, length: { maximum: 500 }
  validates :rating, presence: true
  validates_inclusion_of :rating, in: 1..10
  validate :picture_size

  scope :recent, -> { order(created_at: :desc) }
  scope :store_with, -> (store) {
    joins(:store).where(stores: { name: Store::QUERIES[store] })
  }
  scope :category_with, -> (category_id) {
    joins(:product_category).where(product_categories: { id: category_id })
  }
  scope :reaction_counts, -> (review_ids) {
    where(id: review_ids)
      .joins(:reactions)
      .group("name, id")
      .select("reviews.*, reactions.name, COUNT(reviews.id) AS reaction_count, GROUP_CONCAT(review_reactions.user_id separator ',') AS user_ids")
  }

  def self.get_filtering_list(params)
    params.permit!.slice(:store, :category).to_hash.compact
  end

  def self.base_active_record(page: 1, per_page: 10)
    page ||= 1
    per_page ||= 10
    Review.page(page).per(per_page).recent
  end

  def picture_path
    picture.url
  end

  def increment_comment_count
    increment!(:comment_count)
  end

  def decrement_comment_count
    decrement!(:comment_count)
  end

  private

  def picture_size
    if picture.size > 5.megabytes
      errors.add(:picture, "should be less than 5MB")
    end
  end

  def broadcast_new_review
    ReviewCreationEventBroadcastJob.perform_later(self)
  end
end
