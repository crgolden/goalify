feature 'Sign Up', :devise do
  scenario 'visitor can sign up with valid email address and password' do
    visit new_user_registration_path
    fill_in 'Name', with: Faker::Name.name
    fill_in 'Email', with: Faker::Internet.email
    fill_in 'Password', with: 'password'
    fill_in 'Password confirmation', with: 'password'
    click_button 'Sign up'
    txts = [I18n.t('devise.registrations.signed_up'), I18n.t('devise.registrations.signed_up_but_unconfirmed')]
    expect(page).to have_content /.*#{txts[0]}.*|.*#{txts[1]}.*/
  end

  # Form validation
  scenario 'visitor cannot sign up with invalid email address' do
    visit new_user_registration_path
    fill_in 'Name', with: Faker::Name.name
    fill_in 'Email', with: 'not_an_email'
    fill_in 'Password', with: 'password'
    fill_in 'Password confirmation', with: 'password'
    click_button 'Sign up'
    expect(page).to have_content 'Email is invalid'
  end

  # Form validation
  scenario 'visitor cannot sign up without password' do
    visit new_user_registration_path
    fill_in 'Name', with: Faker::Name.name
    fill_in 'Email', with: Faker::Internet.email
    click_button 'Sign up'
    expect(page).to have_content 'Password can\'t be blank'
  end

  # Form validation
  scenario 'visitor cannot sign up with a short password' do
    visit new_user_registration_path
    fill_in 'Name', with: Faker::Name.name
    fill_in 'Email', with: Faker::Internet.email
    fill_in 'Password', with: 'pass'
    fill_in 'Password confirmation', with: 'pass'
    click_button 'Sign up'
    expect(page).to have_content 'Password is too short'
  end

  # Form validation
  scenario 'visitor cannot sign up without password confirmation' do
    visit new_user_registration_path
    fill_in 'Name', with: Faker::Name.name
    fill_in 'Email', with: Faker::Internet.email
    fill_in 'Password', with: 'password'
    click_button 'Sign up'
    expect(page).to have_content 'Password confirmation doesn\'t match'
  end

  # Form validation
  scenario 'visitor cannot sign up with mismatched password and confirmation' do
    visit new_user_registration_path
    fill_in 'Name', with: Faker::Name.name
    fill_in 'Email', with: Faker::Internet.email
    fill_in 'Password', with: Faker::Internet.password
    fill_in 'Password confirmation', with: Faker::Internet.password
    click_button 'Sign up'
    expect(page).to have_content 'Password confirmation doesn\'t match'
  end
end
