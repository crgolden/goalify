json.meta do
  json.partial! 'api/v1/layouts/pagination', locals: {resource: @subscribers.accessible_by(current_ability)}
end
json.subscribers @subscribers.accessible_by(current_ability), partial: 'api/v1/users/user', as: :user
