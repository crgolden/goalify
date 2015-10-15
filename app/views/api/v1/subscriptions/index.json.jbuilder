json.array!(@subscriptions) do |subscription|
  json.extract! subscription, :id, :completed
  json.url subscription_url(subscription, format: :json)
end
