Feature: User edit
  As a user
  I want to edit my user profile
  So I can change my email address

  Scenario: User changes email address
    Given I am signed in
    When I change my email address
    Then I see an Update Needs Confirmation message

  Scenario: User changes name
    Given I am signed in
    When I change my name
    Then I see an Updated message

#  Scenario: User cannot edit another user's profile
#    Given I am signed in
#    When I try to edit another user's profile
#    Then I see an 'access denied' message
