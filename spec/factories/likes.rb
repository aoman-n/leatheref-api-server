# == Schema Information
#
# Table name: likes
#
#  id         :bigint           not null, primary key
#  user_id    :bigint           not null
#  comment_id :bigint           not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

FactoryBot.define do
  factory :like do
    user { nil }
    review { nil }
  end
end
