json.meta do
  json.pagination do
    json.per_page params[:per_page]
    json.total_pages @comments.total_pages
    json.total_objects @comments.total_count
  end
end
json.comments @comments, partial: 'comment', as: :comment
