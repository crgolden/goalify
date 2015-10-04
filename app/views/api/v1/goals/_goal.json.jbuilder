json.goal do
  json.extract! goal, :id, :title, :text
  json.user api_v1_user_url(goal.user, format: :json)
  json.comments api_v1_goal_comments_url(goal, format: :json)
end