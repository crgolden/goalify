json.meta do
  json.partial! 'api/v1/layouts/pagination', locals: {resource: @scores.accessible_by(current_ability)}
end
json.scores @scores.accessible_by(current_ability), partial: 'api/v1/scores/score', as: :score
