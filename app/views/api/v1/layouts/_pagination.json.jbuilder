json.pagination do
  json.per_page params[:per_page]
  json.total_pages resource.total_pages
  json.total_objects resource.total_count
end
