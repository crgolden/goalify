json.meta do
  json.partial! 'api/v1/layouts/pagination', locals: {resource: @goals}
end
json.goals @goals
