feature 'About page' do
  scenario 'Visit the about page' do
    visit pages_about_path
    expect(page).to have_content 'About the Website'
  end
end
