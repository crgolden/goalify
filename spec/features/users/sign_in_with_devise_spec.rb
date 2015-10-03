feature 'Sign in with Devise', :devise do

  scenario 'user cannot sign in if not registered' do
    visit new_user_session_path
    fill_in 'Email', with: Faker::Internet.email
    fill_in 'Password', with: 'password'
    click_button 'Sign in'
    expect(page).to have_content I18n.t 'devise.failure.not_found_in_database', authentication_keys: 'email'
  end

  scenario 'user can sign in with valid credentials' do
    user = create(:user)
    visit new_user_session_path
    fill_in 'Email', with: user.email
    fill_in 'Password', with: user.password
    click_button 'Sign in'
    expect(page).to have_content I18n.t 'devise.sessions.signed_in'
  end

  scenario 'user cannot sign in with wrong email' do
    user = create(:user)
    visit new_user_session_path
    fill_in 'Email', with: Faker::Internet.email
    fill_in 'Password', with: user.password
    click_button 'Sign in'
    expect(page).to have_content I18n.t 'devise.failure.not_found_in_database', authentication_keys: 'email'
  end

  scenario 'user cannot sign in with wrong password' do
    user = create(:user)
    visit new_user_session_path
    fill_in 'Email', with: user.email
    fill_in 'Password', with: 'password'
    click_button 'Sign in'
    expect(page).to have_content I18n.t 'devise.failure.invalid', authentication_keys: 'email'
  end
end
