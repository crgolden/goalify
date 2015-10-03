FactoryGirl.define do
  factory :comment, class: Comment do
    body Faker::Lorem.paragraph
    association :goal, factory: :goal
    association :user, factory: :goal
  end
end
