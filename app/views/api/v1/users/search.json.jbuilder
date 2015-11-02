json.meta do
  json.partial! 'api/v1/layouts/pagination', locals: {resource: @users}
end
json.users @users
