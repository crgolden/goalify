json.meta do
  json.partial! 'api/v1/layouts/pagination', locals: {resource: @tokens}
end
json.tokens @tokens, partial: 'api/v1/tokens/token', as: :token
