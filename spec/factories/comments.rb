FactoryBot.define do
  factory :comment do
    user { nil }
    review { nil }
    in_reply_to_id { nil }
    comment { "MyText" }
    reply { false }
    in_reply_to_user_id { nil }
  end
end
