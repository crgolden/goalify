json.array! @user.tokens do |token|
  json.partial! 'token', token: token
end