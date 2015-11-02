json.meta do
  json.partial! 'api/v1/layouts/pagination', locals: {resource: @comments.accessible_by(current_ability)}
end
json.comments @comments.accessible_by(current_ability), partial: 'api/v1/comments/comment', as: :comment
