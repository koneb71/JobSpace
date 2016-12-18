# Created by koneb at 12/16/16
Feature: One-way Interview
  # Enter feature description here

  Scenario: create interview
    Given I have this detail
    | id |
    |  3  |
    When I send an one-way interview to:
    | id |
    |      2       |
    And When I click the invite button
    Then I will get a '200' response
    And it should have a field "message" containing "Success!"