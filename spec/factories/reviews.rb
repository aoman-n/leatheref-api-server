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

FactoryBot.define do
  factory :review do
    product_name { "review01" }
    content { "sample reveiw" }
    price { 1000 }
    rating { 5 }
    association :user
    store_id { 1 }
  end
end
