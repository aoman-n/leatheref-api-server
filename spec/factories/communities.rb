FactoryBot.define do
  factory :community do
    sequence(:title) { |n| "hoge#{n} title" }
    description { 'hoge description' }
    permittion_level { 'public' }
    symbol_image { Rack::Test::UploadedFile.new(Rails.root.join('spec/files/surume.jpg'), 'image/jpg') }
    association :owner

    trait :approval do
      permittion_level { 'approval' }
    end
  end
end
