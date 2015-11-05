User.find_or_create_by! email: Rails.application.secrets.admin_email do |user|
  user.name = Rails.application.secrets.admin_name
  user.password = Rails.application.secrets.admin_password
  user.confirmed_at = Time.now
  user.admin!
end

500.times do
  User.create name: Faker::Name.name, email: Faker::Internet.email, confirmed_at: Time.now,
              password: Rails.application.secrets.admin_password
end

500.times do
  Token.create access_token: Faker::Lorem.characters(12), refresh_token: Faker::Lorem.characters(8),
               provider: Faker::Lorem.word, uid: Faker::Number.between(1, 100), expires_at: Time.now,
               user: User.offset(rand User.count).first, image: Faker::Avatar.image
end

1500.times do
  Goal.create title: Faker::Lorem.word, text: Faker::Lorem.paragraph(4),
              user: User.offset(rand User.count).first
end

2500.times do
  subscriber = User.offset(rand User.count).first
  subscription = Goal.offset(rand Goal.count).first
  subscription = Goal.offset(rand Goal.count).first while GoalsUsers.find_by(goal: subscription, user: subscriber).present?
  GoalsUsers.create goal: subscription, user: subscriber
  rand = rand 5
  if rand == (1 || 2)
    GoalsUsers.find_by(goal: subscription, user: subscriber).update completed: true
    if rand == 1
      subscriptions = GoalsUsers.where completed: false
      subscriptions.offset(rand subscriptions.count).first.update completed: true
    end
  end
end

1500.times do
  Comment.create body: Faker::Lorem.paragraph, user: User.offset(rand User.count).first,
                 goal: Goal.offset(rand Goal.count).first
end
