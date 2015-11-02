FactoryGirl.define do
  factory :subscription, class: GoalsUsers do
    completed false
    association :goal, factory: :goal
    association :user, factory: :user
  end
end
