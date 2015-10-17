### UTILITY METHODS ###
def create_visitor
  @visitor ||= {name: Faker::Name.name,
                email: Faker::Internet.email,
                password: 'changeme',
                password_confirmation: 'changeme',
                confirmed_at: Time.now}
end

def find_user
  @user ||= User.find_by(email: @visitor[:email])
end

def create_unconfirmed_user
  create_visitor
  delete_user
  sign_up
  logout @user
end

def create_user
  create_visitor
  delete_user
  @user = create(:user, @visitor)
end

def delete_user
  find_user
  @user.destroy unless @user.nil?
end

def sign_up
  delete_user
  visit new_user_registration_path
  fill_in 'user_name', with: @visitor[:name]
  fill_in 'user_email', with: @visitor[:email]
  fill_in 'user_password', with: @visitor[:password]
  fill_in 'user_password_confirmation', with: @visitor[:password_confirmation]
  click_button 'Sign up'
  find_user
end

def sign_in
  visit new_user_session_path
  fill_in 'user_email', with: @visitor[:email]
  fill_in 'user_password', with: @visitor[:password]
  click_button 'Sign in'
end

def sign_out
  current_driver = Capybara.current_driver
  begin
    Capybara.current_driver = :rack_test
    page.driver.submit :delete, '/users/sign_out', {}
  ensure
    Capybara.current_driver = current_driver
  end
end

def cancel_account
  page.driver.browser.switch_to.alert.accept
end

def goto_edit_registration
  click_link "#{@visitor[:name]}"
  click_link 'Edit registration'
end

def alert_accept(alert, button)
  page.accept_alert alert do
    click_button(button)
  end
end

### GIVEN ###
Given /^I am signed out$/ do
  sign_out
end

Given /^I am not logged in$/ do
  logout @user
end

Given /^I am not signed in$/ do
  current_driver = Capybara.current_driver
  begin
    Capybara.current_driver = :rack_test
    page.driver.submit :delete, '/users/sign_out', {}
  ensure
    Capybara.current_driver = current_driver
  end
end

Given /^I am signed in$/ do
  create_user
  sign_in
end

Given /^I am logged in$/ do
  create_user
  login_as @user, scope: :user
end

Given /^I am not authenticated$/ do
  sign_out # ensure that at least
end

Given /^I am a new, authenticated user$/ do
  email = 'testing@man.net'
  password = 'secretpass'
  User.new(email: email, password: password, password_confirmation: password).save!

  visit new_user_session_path
  fill_in 'user_email', with: email
  fill_in 'user_password', with: password
  click_button 'Sign in'
end

Given /^I exist as a user$/ do
  create_user
end

Given /^I do not exist as a user$/ do
  create_visitor
  delete_user
end

Given /^I exist as an unconfirmed user$/ do
  create_unconfirmed_user
end

### WHEN ###
When /^I sign in with valid credentials$/ do
  create_visitor
  sign_in
end

When /^I log out$/ do
  logout @user
end

When /^I sign out$/ do
  sign_out
end

When /^I sign up with valid user data$/ do
  create_visitor
  sign_up
end

When /^I sign up with an invalid email$/ do
  create_visitor
  @visitor = @visitor.merge(email: 'notanemail')
  sign_up
end

When /^I sign up without a password confirmation$/ do
  create_visitor
  @visitor = @visitor.merge(password_confirmation: '')
  sign_up
end

When /^I sign up without a password$/ do
  create_visitor
  @visitor = @visitor.merge(password: '')
  sign_up
end

When /^I sign up with a mismatched password confirmation$/ do
  create_visitor
  @visitor = @visitor.merge(password_confirmation: Faker::Internet.password)
  sign_up
end

When /^I sign up with a short password$/ do
  create_visitor
  @visitor = @visitor.merge(password: 'pass')
  sign_up
end

When /^I return to the site$/ do
  visit root_path
end

When /^I sign in with a wrong email$/ do
  @visitor = @visitor.merge(email: Faker::Internet.email)
  sign_in
end

When /^I sign in with a wrong password$/ do
  @visitor = @visitor.merge(password: Faker::Internet.password)
  sign_in
end

When /^I change my name$/ do
  goto_edit_registration
  fill_in 'user_name', with: Faker::Name.name
  fill_in 'user_current_password', with: @visitor[:password]
  click_button 'Update'
end

When /^I change my email address$/ do
  goto_edit_registration
  fill_in 'user_email', with: Faker::Internet.email
  fill_in 'user_current_password', with: @visitor[:password]
  click_button 'Update'
end

When /^I delete my account$/ do
  goto_edit_registration
  click_on 'Deactivate User'
  page.accept_confirm do
    click_button('OK')
  end
end

When /^I try to edit another user's profile$/ do
  user = create :user, email: Faker::Internet.email
  visit edit_user_path user
end

When /^I visit another user's profile$/ do
  user = create :user, email: Faker::Internet.email
  visit user_path user
end


### THEN ###
Then /^I should be signed in$/ do
  expect(page).to have_content 'Sign out' && 'Edit registration'
  expect(page).not_to have_content 'Register' || 'Sign In'
end

Then /^I should be signed out$/ do
  expect(page).not_to have_content 'Sign out' || 'Edit registration'
  expect(page).to have_content 'Register' && 'Sign in'
end

Then(/^I see "(.*?)"$/) do |arg1|
  expect(page).to have_content arg1
end

Then /^I see an invalid email message$/ do
  expect(page).to have_content 'Email is invalid'
end

Then /^I see a missing password message$/ do
  expect(page).to have_content 'Password can\'t be blank'
end

Then /^I see a missing password confirmation message$/ do
  expect(page).to have_content 'Password confirmation doesn\'t match Password'
end

Then /^I see a mismatched password message$/ do
  expect(page).to have_content 'Password confirmation doesn\'t match Password'
end

Then(/^I see a 'too short password' message$/) do
  expect(page).to have_content 'Password is too short'
end

Then /^I see an 'access denied' message$/ do
  expect(page).to have_content I18n.t 'cancan.ability.error'
end

Then /^I see my own name$/ do
  expect(page).to have_content @visitor[:name]
end

Then /^I see my own email address$/ do
  expect(page).to have_content @visitor[:email]
end

Then /^I see a Signed Up But Unconfirmed message$/ do
  expect(page).to have_content I18n.t 'devise.registrations.signed_up_but_unconfirmed'
end

Then /^I see a Signed In message$/ do
  expect(page).to have_content I18n.t 'devise.sessions.signed_in'
end

Then /^I see a Signed Up message$/ do
  expect(page).to have_content I18n.t 'devise.registrations.signed_up'
end

Then /^I see a Signed Out message$/ do
  expect(page).to have_content I18n.t 'devise.sessions.signed_out'
end

Then /^I see an Invalid Login message$/ do
  expect(page).to have_content I18n.t 'devise.failure.invalid', authentication_keys: 'email'
end

Then /^I see an Update Needs Confirmation message$/ do
  expect(page).to have_content I18n.t 'devise.registrations.update_needs_confirmation'
end

Then /^I see an Updated message$/ do
  expect(page).to have_content I18n.t 'devise.registrations.updated'
end

Then /^I see a Destroyed message$/ do
  expect(page).to have_content I18n.t 'devise.registrations.destroyed'
end
