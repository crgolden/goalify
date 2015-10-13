feature 'User index page', :devise do
  scenario 'user sees own email address' do
    user = create(:user)
    login_as(user, scope: :user)
    visit user_path(user)
    expect(page).to have_content user.email
  end
end
