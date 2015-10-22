feature 'About page' do
  scenario 'Visit the about page' do
    visit page_path('about')
    expect(page).to have_content 'About'
  end
end
