FactoryBot.define do
  factory :user do
    sequence(:email) { |n| "test#{n}@test.com" }
    sequence(:username) { |n| "username#{n}" }
    name { Faker::Name.name }
    password { '123123123' }
  end
end
