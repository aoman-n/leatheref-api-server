FactoryBot.define do
  factory :comeet do
    message { 'コミーツです！！' }
    association :user
    association :community
  end
end
