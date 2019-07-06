# == Schema Information
#
# Table name: stores
#
#  id         :bigint           not null, primary key
#  name       :string(255)      not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

FactoryBot.define do
  factory :store do
    name { "セブン-イレブン" }
  end
end
