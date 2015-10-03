FactoryGirl.define do
  factory :goal, class: Goal do
    title Faker::Lorem.word
    text Faker::Lorem.paragraph
    association :user, factory: :user
  end
end
