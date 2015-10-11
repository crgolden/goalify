Given /the following (?:goal|goals) exists/ do |goals_table|
  goals_table.hashes.each do |goal|
    create :goal, goal
  end
end

Then /I should see "(.*)" before "(.*)"/ do |e1, e2|
  expect(page.body).to have_content(/.*#{e1}.*#{e2}.*/)
end

Then /I should see all the goals/ do
  Goal.each do |goal|
    expect(page).to have_content(goal.title)
  end
end
