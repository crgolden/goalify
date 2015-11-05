FactoryGirl.define do
  factory :score, class: Score do
    value 50
    association :subscription, factory: :goal
    association :subscriber, factory: :user
    association :user, factory: :user
  end
end
