json.meta do
  json.pagination do
    json.per_page params[:per_page]
    json.total_pages @users.total_pages
    json.total_objects @users.total_count
  end
end
json.users @users, partial: 'user', as: :user
