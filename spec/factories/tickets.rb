FactoryGirl.define do
  factory :ticket do
    title { Faker::Book.title }
    description { Faker::Lorem.paragraph }
    user
  end
end
