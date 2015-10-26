feature 'Navigation links', :devise do
  scenario 'view navigation links' do
    visit root_path
    expect(page).to have_content 'Goals'
    expect(page).to have_content 'Users'
    expect(page).to have_content 'Sign in'
    expect(page).to have_content 'Sign up'
  end
end
