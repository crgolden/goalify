100.times do
  User.create name: Faker::Name.name, email: Faker::Internet.email, confirmed_at: Time.now,
              password: Rails.application.secrets.admin_password,
              password_confirmation: Rails.application.secrets.admin_password
end

250.times do
  Token.create access_token: 'access_token', refresh_token: 'refresh_token',
               provider: Faker::Lorem.word, uid: Faker::Number.between(1, 100), expires_at: Time.now,
               user: User.offset(rand(User.count)).first, image: Faker::Avatar.image
end

1000.times do
  Goal.create title: Faker::Lorem.word, text: Faker::Lorem.paragraph(4),
              user: User.offset(rand(User.count)).first
end

750.times do
  user = User.offset(rand(User.count)).first
  goal = Goal.offset(rand(Goal.count)).first
  goal = Goal.offset(rand(Goal.count)).first while user.subscriptions.find_by(goal: goal).present?
  Subscription.create goal: goal, user: user
  if Random.rand(5) == (1 || 2)
    Subscription.find_by(goal: goal, user: user).update completed: true
  end
end


500.times do
  Comment.create body: Faker::Lorem.paragraph, user: User.offset(rand(User.count)).first,
                 goal: Goal.offset(rand(Goal.count)).first
end

User.find_or_create_by! email: ENV['ADMIN_EMAIL'] do |user|
  user.name = Rails.application.secrets.admin_name
  user.password = Rails.application.secrets.admin_password
  user.password_confirmation = Rails.application.secrets.admin_password
  user.confirmed_at = Time.now
  user.admin!
end
