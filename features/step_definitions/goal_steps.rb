# Add a declarative step here for populating the DB with tasks.
Given /the following (?:goal|goals) exists/ do |goals_table|
  goals_table.hashes.each do |goal|
    # each returned element will be a hash whose key is the table header.
    # you should arrange to add that task to the database here.
    FactoryGirl.create(:goal, goal)
  end
end

# Make sure that one string (regexp) occurs before or after another one
#   on the same page
Then /I should see "(.*)" before "(.*)"/ do |e1, e2|
  #  ensure that that e1 occurs before e2.
  #  page.body is the entire content of the page as a string.
  expect(page.body).to have_content(/.*#{e1}.*#{e2}.*/)
end

Then /I should see all the goals/ do
  # Make sure that all the goals in the app are visible in the table
  Goal.each do |goal|
    expect(page).to have_content(goal.title)
  end
end
