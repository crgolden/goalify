json.meta do
  json.partial! 'api/v1/layouts/pagination', locals: {resource: @users.accessible_by(current_ability)}
end
json.users @users.accessible_by(current_ability)
