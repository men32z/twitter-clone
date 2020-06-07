FactoryBot.define do
  factory :post do
    association :user
    message { Faker::Lorem.sentence(word_count: 10) }
  end
end
