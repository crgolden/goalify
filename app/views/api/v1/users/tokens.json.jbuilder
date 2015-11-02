json.meta do
  json.partial! 'api/v1/layouts/pagination', locals: {resource: @tokens.accessible_by(current_ability)}
end
json.tokens @tokens.accessible_by(current_ability), partial: 'api/v1/tokens/token', as: :token
