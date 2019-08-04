FactoryBot.define do
  factory :join_request do
    message { '承認しておくれやす' }
    association :user
    association :community
  end
end
