json.token do
  json.extract! token, :id, :provider, :uid, :access_token, :refresh_token, :image, :user_id
end
