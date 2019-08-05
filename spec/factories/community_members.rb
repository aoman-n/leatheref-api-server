FactoryBot.define do
  factory :community_member do
    association :member
    association :community
  end
end
