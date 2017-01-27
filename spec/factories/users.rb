# frozen_string_literal: true
FactoryGirl.define do
  factory :user do
    name { Faker::Name.name }
    email { Faker::Internet.email }
    password 'qweasd'
    password_confirmation 'qweasd'
  end
end
