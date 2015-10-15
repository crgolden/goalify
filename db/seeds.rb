75.times do
  User.create name: Faker::Name.name, email: Faker::Internet.email, confirmed_at: Time.now,
              password: ENV['ADMIN_PASSWORD'], password_confirmation: ENV['ADMIN_PASSWORD']
end

50.times do
  Token.create access_token: 'access_token', refresh_token: 'refresh_token',
               provider: Faker::Lorem.word, uid: Faker::Number.between(1, 100), expires_at: Time.now,
               user: User.offset(rand(User.count)).first, image: Faker::Avatar.image
end

250.times do
  Goal.create title: Faker::Lorem.word, text: Faker::Lorem.word,
              user: User.offset(rand(User.count)).first
end

500.times do
  Subscription.create goal: Goal.offset(rand(Goal.count)).first, user: User.offset(rand(User.count)).first
end

500.times do
  Comment.create body: Faker::Lorem.paragraph, user: User.offset(rand(User.count)).first,
                 goal: Goal.offset(rand(Goal.count)).first
end

User.find_or_create_by! email: ENV['ADMIN_EMAIL'] do |user|
  user.name = ENV['ADMIN_NAME']
  user.password = ENV['ADMIN_PASSWORD']
  user.password_confirmation = ENV['ADMIN_PASSWORD']
  user.confirmed_at = Time.now
  user.admin!
end
