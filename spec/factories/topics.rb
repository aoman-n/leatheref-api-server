FactoryBot.define do
  factory :topic do
    title { 'トピックタイトルhoge!' }
    association :community
    association :owner
  end
end
