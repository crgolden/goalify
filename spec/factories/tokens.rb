FactoryGirl.define do
  factory :token, class: Token do
    access_token 'access_token'
    refresh_token 'refresh_token'
    provider 'provider'
    uid '12345'
    expires_at Time.at(Faker::Date.forward(1).to_datetime)
    image Faker::Avatar.image
    association :user, factory: :user
  end
end
