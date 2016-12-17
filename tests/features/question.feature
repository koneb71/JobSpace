Feature: Question Template
  Create a set of question for the one-way interview

  Scenario: Create Question
    Given the details:
    | name | one_way_interview_id|
    |   Why we should hire you?   | 1 |
    When I submit it
    Then I will get a '200' response
    And it should have a field "message" containing "Question Added"