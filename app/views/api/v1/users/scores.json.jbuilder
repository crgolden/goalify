json.meta do
  json.partial! 'api/v1/layouts/pagination', locals: {resource: @scores}
end
json.scores @scores, partial: 'api/v1/scores/score', as: :score
