# == Schema Information
#
# Table name: reviews
#
#  id                  :bigint           not null, primary key
#  product_name        :string(255)      not null
#  content             :text(65535)      not null
#  picture             :string(255)
#  price               :integer
#  rating              :integer          not null
#  stamp_count         :integer          default(0)
#  user_id             :bigint
#  store_id            :bigint
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#  product_category_id :bigint
#

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

  # default_scope { recent }

  scope :recent, -> { order(created_at: :desc) }
  scope :store_with, -> (store) {
    joins(:store).where(stores: { name: Store::QUERIES[store] })
  }
  scope :category_with, -> (category_id) {
    joins(:product_category).where(product_categories: { id: category_id })
  }
  # scope :with_store?, -> (store) {
  #   store ? store_with(store) : tap {}
  # }
  # scope :with_category?, -> (category_id) {
  #   category_id ? category_with(category_id) : tap {}
  # }

  def picture_path
    picture.url
  end

  private

  # アップロードされた画像のサイズをバリデーションする
  def picture_size
    if picture.size > 5.megabytes
      errors.add(:picture, "should be less than 5MB")
    end
  end

  def broadcast_new_review
    ActionCable
      .server
      .broadcast(
        ReviewChannel::BROADCAST_CHANNEL,
        self,
      )
  end
end
