Feature: API

  Background:

    Given basic auth using:
      | username | tester  |
      | password | iloveqa |
    And I set the variables:
      | base | http://localhost:3000 |
    And I am using the default content type: "application/json"

  Scenario: happy path get payments
    When I send a "GET" request to "{base}/candidates"
    Then receive status 200

  Scenario: happy path getPaymentsById

    Given I set the placeholder 'id' using the json path '$.[0].id' from the last 'GET' to '{base}/candidates'
    When I send a "GET" request to "{base}/candidates/{id}"
    Then receive status 200
#
#
    Scenario: Happy path create Candidate
    Given I send a "POST" request to "{base}/candidates"
    And send:
      """

      {
       "firstName": "robert",
       "lastName": "Trump",
       "matchingScore": 3,
       "vacancyTitle": "President"
      }
      """

      And receive status 201
      When I send a "GET" request to "{base}/candidates/"

      Then receive status 200
      Then json path at "$.[-1:].firstName" should equal "robert"


  Scenario: Happy path update Candidate
    Given I set the placeholder 'id' using the json path '$.[0].id' from the last 'GET' to '{base}/candidates'
    When I send a "PUT" request to "{base}/candidates/{id}"
    And send:
    """
      {
       "firstName": "Abhishek",
       "lastName": "Trump",
       "matchingScore": 3,
       "vacancyTitle": "President"
      }
   """
      And receive status 200
      When I send a "GET" request to "{base}/candidates/{id}"
      Then receive status 200
      Then the response body json path at "$.firstName" should equal "Abhishek"


  @Bug
  Scenario: Happy path patch Candidate
    Given I set the placeholder 'id' using the json path '$.[0].id' from the last 'GET' to '{base}/candidates'
    When I send a "PATCH" request to "{base}/candidates/{id}"
    And send:
    """
      {
       "firstName": "Donald"
      }
   """
    And receive status 200
    When I send a "GET" request to "{base}/candidates/{id}"
    Then receive status 200
    Then the response body json path at "$.firstName" should equal "Donald"

  @Bug
  Scenario: Verify  create Candidate api does not allow empty records
    Given I send a "POST" request to "{base}/candidates"
    And send:
      """
      {
      }
      """

     Then receive status 500


  @Bug

  Scenario: Happy path delete Candidate
    Given I set the placeholder 'id' using the json path '$.[0].id' from the last 'GET' to '{base}/candidates'
    When I send a "DELETE" request to "{base}/candidates/{id}"
    Then receive status 204
#    When I send a "GET" request to "{base}/candidates/{id}"
#    Then receive status 404

  @Bug
  Scenario: Find candidate which does not exists in the system.
    When I send a "GET" request to "{base}/candidates/{id}"
    Then receive status 404