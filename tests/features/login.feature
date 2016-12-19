Feature: Login Account

  Scenario: Successfully Login
    Given login details
      | email | password |
      | neiell@ymail.com| password |
    When I click login button
    Then get a '200' response
    And message "Successfully Logged In" is returned