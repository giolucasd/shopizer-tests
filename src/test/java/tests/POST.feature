Feature: Create Customer API

  Background:
    * def adminAuthResponse = call read('AdminAuth.feature')
    * def token = adminAuthResponse.response.token
    * url 'http://localhost:8080/api/v1/private/customer'
    * header Authorization = 'Bearer ' + token

  Scenario Outline: Test arguments domain.

    Given path '/'
    And request { "billing": { "company":"", "address":"<billing_address>", "city":"<billing_city>", "postalCode":"<billing_postalCode>", "stateProvince":"<billing_stateProvince>", "country":"<billing_country>", "zone":"<billing_zone>", "firstName":"<billing_firstName>", "lastName":"<billing_lastName>", "phone":"<billing_phone>"}, "delivery": { "company":"", "address":"", "city":"", "postalCode":"", "stateProvince":"", "country":"", "zone":"", "firstName":"", "lastName":"" }, "emailAddress":"<emailAddress>", "groups":[], "language":"en", "userName":"" }
    When method post
    Then status <response_status>
    Then print response

    Examples:
      | read('post-entries.csv') |