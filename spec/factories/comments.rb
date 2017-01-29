FactoryGirl.define do
  factory :comment do
    body "MyText"
    association :author, factory: :user
    ticket
  end
end
