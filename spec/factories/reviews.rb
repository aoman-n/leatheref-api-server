FactoryBot.define do
  factory :review do
    product_name { "MyString" }
    content { "MyText" }
    picture { "MyString" }
    price { 1 }
    rating { 1 }
    stamp_count { 1 }
    user { nil }
    store { nil }
  end
end
