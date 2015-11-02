json.meta do
  json.partial! 'api/v1/layouts/pagination', locals: {resource: @subscribers}
end
json.subscribers @subscribers, partial: 'api/v1/users/user', as: :user
