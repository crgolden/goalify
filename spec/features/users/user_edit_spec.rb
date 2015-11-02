feature 'User edit', :devise do

  scenario 'user changes email address' do
    user = create(:user)
    login_as(user, scope: :user)
    visit edit_user_registration_path(user)
    fill_in 'Email', with: 'newemail@example.com'
    fill_in 'Current password', with: user.password
    click_button 'Update'
    txts = [I18n.t('devise.registrations.updated'), I18n.t('devise.registrations.update_needs_confirmation')]
    expect(page).to have_content(/.*#{txts[0]}.*|.*#{txts[1]}.*/)
  end

  scenario 'user cannot cannot edit another user\'s profile', :me do
    me = create(:user)
    other = create(:user, email: 'other@example.com')
    login_as(me, scope: :user)
    visit edit_user_registration_path(other)
    expect(page).to have_content 'User Edit'
    expect(page).to have_field('Email', with: me.email)
    expect(page).not_to have_content other.email
  end
end
