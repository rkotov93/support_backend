# frozen_string_literal: true
FactoryGirl.define do
  factory :ticket do
    title { Faker::Book.title }
    description { Faker::Lorem.paragraph }
    association :author, factory: :user
  end
end
