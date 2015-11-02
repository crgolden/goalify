json.token do
  json.extract! token, :id, :provider, :uid, :access_token, :refresh_token, :expires_at, :image, :user_id
end
