feature 'User profile page', :devise do

  scenario 'user sees own profile' do
    user = create :user
    login_as user, scope: :user
    visit user_path(user)
    expect(page).to have_content user.name
  end

  scenario 'user can see another user\'s profile' do
    me = create :user
    other = create :user, email: Faker::Internet.email
    login_as me, scope: :user
    visit user_path(other)
    expect(page).to have_content other.name
  end

  scenario 'user can\'t see another user\'s token' do
    me = create :user
    other = create :user, email: 'other@example.com'
    token = create :token, user: other
    login_as me, scope: :user
    visit token_path(token)
    expect(page).to have_content I18n.t 'cancan.ability.error'
  end
end
