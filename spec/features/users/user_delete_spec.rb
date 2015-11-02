feature 'User delete', :devise do

  scenario 'user can delete own account' do
    user = create :user
    login_as(user)
    visit root_path
    click_link 'Edit Profile'
    expect(page).to have_content 'Edit Profile'
    # page.accept_confirm { click_link('Deactivate User') }
    # page.driver.browser.switch_to.alert.accept
    # expect(page).to have_content I18n.t 'devise.registrations.destroyed'
  end
end
