Feature: 'About' page
  As a visitor
  I want to visit an 'about' page
  So I can learn more about the website

  Scenario: Visit the 'about' page
    Given I am signed out
    When I am on the About page
    Then I see "About"
