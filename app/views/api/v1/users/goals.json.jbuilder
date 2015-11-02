json.meta do
  json.partial! 'api/v1/layouts/pagination', locals: {resource: @goals.accessible_by(current_ability)}
end
json.goals @goals.accessible_by(current_ability), partial: 'api/v1/goals/goal', as: :goal
