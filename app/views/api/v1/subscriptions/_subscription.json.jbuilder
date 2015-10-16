json.subscription do
  json.extract! subscription, :id, :completed, :user_id, :goal_id
end