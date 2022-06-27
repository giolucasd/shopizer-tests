Feature: Get Customer API

  Background:
    Given url 'http://localhost:8080/api/v1/private/customer/'
    And def token = "eyJhbGciOiJIUzUxMiJ9.eyJzdWIiOiJhZG1pbkBzaG9waXplci5jb20iLCJhdWQiOiJhcGkiLCJleHAiOjE2NTYzNTI5NTgsImlhdCI6MTY1NTc0ODE1OH0.7Lig7jDk52H9Cgx_XpAH95B5CDET0JWnxvQHPA8DJRIFP2ukgCBa0k4P1BVlG76Ta4T0xk0qSy62bEkOP_HInA"
    And header Authorization = 'Bearer ' + token

  Scenario: Test Getting Created Customer.

    Given path '/'
    And request { "billing": { "company":"", "address":"Add St 123", "city":"New York", "postalCode":"12345", "stateProvince":"NY", "country":"US", "zone":"NY", "firstName":"John", "lastName":"Doe", "phone":"+1-202-555-0124"}, "delivery": { "company":"", "address":"", "city":"", "postalCode":"", "stateProvince":"", "country":"", "zone":"", "firstName":"", "lastName":"" }, "emailAddress":"gettest@email.com", "groups":[], "language":"en", "userName":"" }
    And method post
    And def id = response.id
    And print response
    When path '/' + id
    And method get
    Then status 200
    And response.id = id
    And print response

  Scenario Outline: Test ID domain.

    Given path '/<customer_id>'
    When method get
    Then status <response_status>
    And print response

    Examples:
      | customer_id | response_status  |
      | -1          | 404              |
      | \'1\'       | 500              |
      | \'nonint\'  | 500              |