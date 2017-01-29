# frozen_string_literal: true
FactoryGirl.define do
  factory :comment do
    body { Faker::Lorem.paragraph }
    association :author, factory: :user
    ticket
  end
end
