Feature: Sign in
  As a user
  I want to sign in
  So I can visit protected areas of the site

  Scenario: User cannot sign in if not registered
    Given I am signed out
    And I do not exist as a user
    When I sign in with valid credentials
    Then I see an Invalid Login message
    And I should be signed out

  Scenario: User can sign in with valid credentials
    Given I am signed out
    And I exist as a user
    When I sign in with valid credentials
    Then I see a Signed In message
    And I should be signed in

  Scenario: User cannot sign in with wrong email
    Given I am signed out
    And I exist as a user
    When I sign in with a wrong email
    Then I see an Invalid Login message
    And I should be signed out

  Scenario: User cannot sign in with wrong password
    Given I am signed out
    And I exist as a user
    When I sign in with a wrong password
    Then I see an Invalid Login message
    And I should be signed out

#  Scenario: User can sign in with valid OmniAuth account
#    Given I am a visitor
#    And I have a valid account
#    When I sign in
#    Then I see a success message

#  Scenario: User cannot sign in with invalid OmniAuth account
#    Given I am a visitor
#    And I have no account
#    When I sign in
#    Then I see an authentication error message
