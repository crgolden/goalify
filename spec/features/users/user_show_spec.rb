feature 'User profile page', :devise do

  scenario 'user sees own profile' do
    user = create :user
    login_as user
    visit user_path user
    expect(page).to have_content user.name
  end

  scenario 'user can see another user\'s profile' do
    me = create :user
    other = create :user, email: Faker::Internet.email
    login_as me
    visit user_path other
    expect(page).to have_content other.name
  end

end
