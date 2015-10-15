FactoryGirl.define do
  factory :score, class: Score do
    value 50
    association :goal, factory: :goal
    association :user, factory: :goal
  end
end
