json.user do
  json.extract! user, :id, :name, :email
  json.goals user.goals do |goal|
    json.partial! 'api/v1/goals/goal', goal: goal
  end
  json.comments user.comments do |comment|
    json.partial! 'api/v1/comments/comment', comment: comment
  end
  json.tokens user.tokens do |token|
    json.partial! 'api/v1/tokens/token', token: token
  end
end
