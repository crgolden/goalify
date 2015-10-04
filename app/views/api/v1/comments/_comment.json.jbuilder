json.comment do
  json.extract! comment, :id, :body
  json.user api_v1_user_url(comment.user, format: :json)
  json.goal api_v1_goal_url(comment.goal, format: :json)
end