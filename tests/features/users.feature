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


Scenario: Get User
    Given user id '1' is in the system
    When I retrieve the user '1'
    Then I get the '200' response
    And the following user details are shown:
      | id | fname | mname | lname | email | birthday | gender | acc_level | title | status |
      | 1       | Dexter  | Atis | Esin | god_dexter@yahoo.com | Sat, 19 Aug 1995 00:00:00 GMT | male | 1 | White Hat Hacker | unemployed |


Scenario: Get User not in the Database
    Given I access the user id '4'
    When I retrieve the user JSON result
    Then I get the '200' response
    And it should have a user field 'status' containing 'ok'
    And it should have a user field 'message' containing 'No entries found'
    And it should have a user field 'count' containing '0'
    And it should have an empty field 'entries'


