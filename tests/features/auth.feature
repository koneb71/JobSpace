Feature: User Auth
  login, logout, change password

  Scenario: Successfully Login
    Given login details:
      | email             | password |
      | neiell@ymail.com | password           |
    When I click login button
    Then I will get a '200' response
    And it should have a field "message" containing "Successfully Logged In"