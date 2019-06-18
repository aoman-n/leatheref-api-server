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

  validates :product_name, presence: true, length: { minimum: 4 }
  validates :content, presence: true, length: { maximum: 500 }
  validates :rating, presence: true
  validates_inclusion_of :rating, in: 1..10

  scope :recent, -> { order(created_at: :desc) }
end
