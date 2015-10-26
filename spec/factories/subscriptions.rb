FactoryGirl.define do
  factory :subscription, class: Subscription do
    completed false
    association :goal, factory: :goal
    association :user, factory: :user
  end
end
