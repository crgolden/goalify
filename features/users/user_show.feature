Feature: User profile page
  As a user
  I want to visit my user profile page
  So I can see my personal account data

  Scenario: User sees own profile
    Given I am signed in
    When I go to the User profile page
    Then I see my own email address

  Scenario: User cannot see another user's profile
    Given I am signed in
    When I visit another user's profile
