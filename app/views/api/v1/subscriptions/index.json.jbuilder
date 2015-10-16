json.meta do
  json.pagination do
    json.per_page params[:per_page]
    json.total_pages @subscriptions.total_pages
    json.total_objects @subscriptions.total_count
  end
end
json.subscriptions @subscriptions, partial: 'subscription', as: :subscription
