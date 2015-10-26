FactoryGirl.define do

  factory :user, class: User do
    name Faker::Name.name
    email Faker::Internet.email
    password Faker::Internet.password
    password_confirmation { password }
    confirmed_at { 1.days.ago }
    role 'regular'
  end

  factory :admin, class: User do
    name Faker::Name.name
    email Faker::Internet.email
    password Faker::Internet.password
    password_confirmation { password }
    confirmed_at { 1.days.ago }
    role 'admin'
  end

end
