Feature: Get Customer API

  Background:
    * def adminAuthResponse = call read('AdminAuth.feature')
    * def token = adminAuthResponse.response.token
    Given url 'http://localhost:8080/api/v1/private/customer/'
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