Feature: User index page
  As a user
  I want to see a list of users
  So I can see who has registered

  Scenario: User listed on index page
    Given I am signed in
    When I am on the User index page
    Then I see my own name
