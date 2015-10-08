json.array! @goal.comments do |comment|
  json.partial! 'comment', comment: comment
end
