json.goal do
  json.extract! goal, :id, :title, :text, :user
  json.comments goal.comments do |comment|
    json.partial! 'api/v1/comments/comment', comment: comment
  end
end
