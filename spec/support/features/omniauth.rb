module Omniauth
  module Mock
    def auth_mock
      OmniAuth.config.mock_auth[:default] =
          OmniAuth::AuthHash.new(
              info: {
                  name: Faker::Name.name,
                  email: Faker::Internet.email
              }, uid: '123545',
              credentials: {
                  token: 'mock_token',
                  secret: 'mock_secret',
                  expires_at: Time.at(Faker::Date.forward(1).to_datetime)
              }
          )
    end
  end
end