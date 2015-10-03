feature 'Sign out', :devise do
  scenario 'user signs out successfully' do
    user = create :user
    login_as user
    visit authenticated_root_path
    expect(page).to have_content 'User Home' && 'Sign out'
    click_link 'Sign out'
    expect(page).to have_content I18n.t 'devise.sessions.signed_out'
  end
end
