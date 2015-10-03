feature 'User profile page', :devise do

  scenario 'user sees own profile' do
    user = create(:user)
    login_as(user, scope: :user)
    visit user_path(user)
    expect(page).to have_content 'User'
    expect(page).to have_content user.email
  end

  scenario 'user can see another user\'s profile' do
    me = create(:user)
    other = create(:user, email: 'other@example.com')
    login_as(me, scope: :user)
    visit user_path(other)
    expect(page).to have_content other.email
  end

  scenario 'user can\'t see another user\'s token' do
    me = create(:user)
    other = create(:user, email: 'other@example.com')
    token = create(:token, user: other)
    login_as(me, scope: :user)
    Capybara.current_session.driver.header 'Referer', root_path
    visit token_path token
    expect(page).to have_content 'Access denied!'
  end
end