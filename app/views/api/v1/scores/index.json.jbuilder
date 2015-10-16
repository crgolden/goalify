json.meta do
  json.pagination do
    json.per_page params[:per_page]
    json.total_pages @scores.total_pages
    json.total_objects @scores.total_count
  end
end
json.scores @scores, partial: 'score', as: :score
