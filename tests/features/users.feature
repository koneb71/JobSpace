Feature: Adding, Updating, and Retrieve User details

  Scenario: Adding User
    Given I have the following user details:
      | fname       | mname    | lname     | email            | birthday   | gender | password | acc_level | title         | status     |
      | Neiell Care | Lumindas | Paradiang | neiell@ymail1.com | 1995-08-20 | male   | password | 1         | Web Developer | unemployed |
    When I click the register button
    Then I will get a '200' response
    And it should have a field "message" containing "OK"


  Scenario: Adding duplicate User
    Given I have the following user details:
      | fname       | mname    | lname     | email            | birthday   | gender | password | acc_level | title         | status     |
      | Neiell Care | Lumindas | Paradiang | neiell@ymail.com | 1995-08-20 | male   | password | 1         | Web Developer | unemployed |
    When I click the register button
    Then I will get a '200' response
    And And it should have a field "message" containing "ALREADY EXISTS!"


  Scenario: Adding User with empty email address field
    Given I have the following user details:
      | fname       | mname    | lname     | email | birthday   | gender | password | acc_level | title         | status     |
      | Neiell Care | Lumindas | Paradiang |       | 1995-08-20 | male   | password | 1         | Web Developer | unemployed |
    When I click the register button
    Then I will get a '200' response
    And it should have a field "message" containing "Error"

  Scenario: Adding user with empty first name field
    Given I have the following user details:
      | fname | mname    | lname     | email             | birthday   | gender | password | acc_level | title         | status     |
      |       | Lumindas | Paradiang | neiel1l@ymail.com | 1995-08-20 | male   | password | 1         | Web Developer | unemployed |
    When I click the register button
    Then I will get a '200' response
    And it should have a field "message" containing "Error"


  Scenario: Adding user with empty middle name field
    Given I have the following user details:
      | fname       | mname | lname     | email             | birthday   | gender | password | acc_level | title         | status     |
      | Neiell Care |       | Paradiang | neiel1l@ymail.com | 1995-08-20 | male   | password | 1         | Web Developer | unemployed |
    When I click the register button
    Then I will get a '200' response
    And it should have a field "message" containing "Error"


  Scenario: Adding user with empty lname field
    Given I have the following user details:
      | fname       | mname    | lname | email             | birthday   | gender | password | acc_level | title         | status     |
      | Neiell Care | Lumindas |       | neiel1l@ymail.com | 1995-08-20 | male   | password | 1         | Web Developer | unemployed |
    When I click the register button
    Then I will get a '200' response
    And it should have a field "message" containing "Error"


  Scenario: Add user with empty password field
    Given I have the following user details:
      | fname       | mname    | lname     | email             | birthday   | gender | password | acc_level | title         | status     |
      | Neiell Care | Lumindas | Paradiang | neiel1l@ymail.com | 1995-08-20 | male   |          | 1         | Web Developer | unemployed |
    When I click the register button
    Then I will get a '200' response
    And it should have a field "message" containing "Error"

  Scenario: Retrieving a user
    Given a user id '3'
    When I retrieve user account id '3'
    Then I will get a '200' response
    And the following user details are returned:
      | id | fname       | mname    | lname     | email            | birthday                      | gender | acc_level | title         | status     |
      | 3 | Neiell Care | Lumindas | Paradiang | neiell@ymail.com | Sun, 20 Aug 1995 00:00:00 GMT | male   | 1         | Web Developer | unemployed |
#
#
#	Scenario: Update user details
#		Given I have the following user details:
#		  | id_personnel | fname | mname | lname | email | personnel_password | hotel_id |
#		  | 1 | Kristel | Ahlaine | Pabillaran | pabillarankristel@ymail.com | asdasd | 1 |
#		When I update the user details into the following:
#		  | id_personnel | fname | mname | lname | email | personnel_password | hotel_id |
#		  | 1 | Kristel | Ahlaine | Gem | pabillarankristel@ymail.com | asdasd | 1 |
#		Then I will get a '200' response
#		And it should have a field "status" containing "success"
#
#
#	Scenario: Deactivate user
#		Given user id '1'
#		When I click the deactivate button
#		Then i will get a '200' response
#		And it should have a field "status" containing "success"

Feature: Log In and Log Out

  Scenario: Log In
    Given I am on "/"
    When I follow "Log In"
      And I fill in "Username" with "dextergod"
      And I fill in "Password" with "testpassword"
      And I press "Log in"
    Then I should see "Log out"
      And I should see "My account"

  Scenario: Logs Out
    Given I am on "/"
    When I follow "Log In"
      And I fill in "Username" with "dextergod"
      And I fill in "Password" with "testpassword"
      And I press "Log in"
      And I follow "Log out"
    Then I should see "Log in"
      And I should not see "My account"

  Scenario: Log In With Wrong Credentials
    Given I am on "/"
    When I follow "Log In"
      And I fill in "Username" with "dexterbot"
      And I fill in "Password" with "textpassword"
      And I press "Log in"
    Then I should see "Sorry, unrecognized username or password."
      And I should not see "My account"