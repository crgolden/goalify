json.meta do
  json.partial! 'api/v1/layouts/pagination', locals: {resource: @comments}
end
json.comments @comments, partial: 'api/v1/comments/comment', as: :comment
