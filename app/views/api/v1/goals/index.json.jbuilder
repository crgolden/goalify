json.meta do
  json.pagination do
    json.per_page params[:per_page]
    json.total_pages @goals.total_pages
    json.total_objects @goals.total_count
  end
end
json.goals @goals, partial: 'goal', as: :goal
