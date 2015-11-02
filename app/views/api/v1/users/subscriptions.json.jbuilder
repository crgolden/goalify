json.meta do
  json.partial! 'api/v1/layouts/pagination', locals: {resource: @subscriptions.accessible_by(current_ability)}
end
json.scores @subscriptions.accessible_by(current_ability), partial: 'api/v1/goals/goal', as: :goal
