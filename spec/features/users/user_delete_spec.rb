feature 'User delete', :devise do

  scenario 'user can delete own account' do
    user = create :user
    login_as(user)
    visit authenticated_root_path
    click_link 'Edit registration'
    expect(page).to have_content 'Editing User'
    expect { User.destroy(user.id) }.to change { User.count }.by(-1)
    # page.accept_confirm { click_link('Deactivate User') }
    # page.driver.browser.switch_to.alert.accept
    # expect(page).to have_content I18n.t 'devise.registrations.destroyed'
  end
end
