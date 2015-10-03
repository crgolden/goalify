Feature: Sign up
  As a visitor
  I want to sign up
  So I can visit protected areas of the site

  Background:
    Given I am signed out

  Scenario: Visitor signs up with valid data
    When I sign up with valid user data
    Then I see a Signed Up But Unconfirmed message

  Scenario: Visitor signs up with invalid email
    When I sign up with an invalid email
    Then I see an invalid email message

  Scenario: Visitor signs up without password
    When I sign up without a password
    Then I see a missing password message

  Scenario: Visitor signs up without password confirmation
    When I sign up without a password confirmation
    Then I see a missing password confirmation message

  Scenario: Visitor signs up with mismatched password and confirmation
    When I sign up with a mismatched password confirmation
    Then I see a mismatched password message

  Scenario: Visitor cannot sign up with a short password
    When I sign up with a short password
    Then I see a 'too short password' message

  Scenario Outline: Creating a new account
    Given I am not authenticated
    When I go to register
    And I fill in "user_name" with "<name>"
    And I fill in "user_email" with "<email>"
    And I fill in "user_password" with "<password>"
    And I fill in "user_password_confirmation" with "<password>"
    And I press "Sign up"
    Then I see a Signed Up But Unconfirmed message

    Examples:
      | name    | email           | password   |
      | Testing | testing@man.net | secretpass |
      | Foo     | foo@bar.com     | fr33z3zz   |
