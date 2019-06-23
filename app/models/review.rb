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

  mount_uploader :picture, PictureUploader

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
  scope :category_with, -> (id) {
    joins(:product_category).where(product_categories: { id: id })
  }
  scope :with_store?, -> (store) {
    store ? store_with(store) : tap {}
  }
  scope :with_category?, -> (category_id) {
    category_id ? category_with(category_id) : tap {}
  }

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
end
