FactoryGirl.define do
  factory :score, class: Score do
    value 50
    association :subscription, factory: :subscription
  end
end
