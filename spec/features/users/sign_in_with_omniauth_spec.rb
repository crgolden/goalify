feature 'Sign in with Omniauth', :omniauth do

  scenario 'user can sign in with valid Google account' do
    auth_mock
    OmniAuth.config.add_mock(:google_oauth2)
    visit root_path
    click_link 'Sign in with Google'
    expect(page).to have_content I18n.t 'devise.omniauth_callbacks.success', kind: 'Google Oauth2'
    OmniAuth.config.mock_auth[:google_oauth2] = nil
  end

  scenario 'user cannot sign in with invalid Google account' do
    OmniAuth.config.mock_auth[:google_oauth2] = :invalid_credentials
    visit root_path
    click_link 'Sign in with Google'
    expect(page).to have_content I18n.t 'devise.omniauth_callbacks.failure', kind: 'GoogleOauth2', reason: 'Invalid credentials'
    OmniAuth.config.mock_auth[:google_oauth2] = nil
  end

  scenario 'user can sign in with valid Facebook account' do
    auth_mock
    OmniAuth.config.add_mock(:facebook)
    visit root_path
    click_link 'Sign in with Facebook'
    expect(page).to have_content I18n.t 'devise.omniauth_callbacks.success', kind: 'Facebook'
    OmniAuth.config.mock_auth[:facebook] = nil
  end

  scenario 'user cannot sign in with invalid Facebook account' do
    OmniAuth.config.mock_auth[:facebook] = :invalid_credentials
    visit root_path
    click_link 'Sign in with Facebook'
    expect(page).to have_content I18n.t 'devise.omniauth_callbacks.failure', kind: 'Facebook', reason: 'Invalid credentials'
    OmniAuth.config.mock_auth[:facebook] = nil
  end
end
