json.meta do
  json.partial! 'api/v1/layouts/pagination', locals: {resource: @subscriptions}
end
json.scores @subscriptions, partial: 'api/v1/goals/goal', as: :goal
