json.token do
  json.extract! token, :id, :provider, :uid
  json.user api_v1_user_url(token.user, format: :json)
end
