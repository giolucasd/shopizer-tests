Feature: Update Customer API

  Background:
    Given url 'http://localhost:8080/api/v1/private/customer/'
    And def token = "eyJhbGciOiJIUzUxMiJ9.eyJzdWIiOiJhZG1pbkBzaG9waXplci5jb20iLCJhdWQiOiJhcGkiLCJleHAiOjE2NTY1MjMwNjIsImlhdCI6MTY1NTkxODI2Mn0.hFqkpp5nxdTNDSjgcA6Qpvm5gXWZ_fbjZwuDb0KW7L09rJmAjyKW1CUEaFQCdYdfK73uuTf1Q9zd3U-86F-wnQ"
    And header Authorization = 'Bearer ' + token

  Scenario Outline: Test Update Created User.
    And path '/'
    And request { "billing": { "company":"", "address":"Add St 1234", "city":"San Francisco", "postalCode":"54321", "stateProvince":"CA", "country":"US", "zone":"CA", "firstName":"John", "lastName":"Lennon", "phone":"+1-202-666-0124"}, "delivery": { "company":"", "address":"", "city":"", "postalCode":"", "stateProvince":"", "country":"", "zone":"", "firstName":"", "lastName":"" }, "emailAddress":<original_mail>, "groups":[], "language":"en", "userName":"" }
    And method post
    And def id = response.id
    And print response
    When path '/' + id
    And request { "billing": { "company":"", "address":<billing_address>, "city":<billing_city>, "postalCode":<billing_postalCode>, "stateProvince":<billing_stateProvince>, "country":<billing_country>, "zone":<billing_zone>, "firstName":<billing_firstName>, "lastName":<billing_lastName>, "phone":<billing_phone>}, "delivery": { "company":"", "address":"", "city":"", "postalCode":"", "stateProvince":"", "country":"", "zone":"", "firstName":"", "lastName":"" }, "emailAddress":<emailAddress>, "groups":[], "language":"en", "userName":"" }
    And method put
    Then status <response_status>
    Then print response

    Examples:
      | read('update-entries.csv') |

  Scenario Outline: Test ID domain.

    Given path '/<customer_id>'
    And request { "billing": { "company":"", "address":"Add St 1234", "city":"San Francisco", "postalCode":"54321", "stateProvince":"CA", "country":"US", "zone":"CA", "firstName":"John", "lastName":"Lennon", "phone":"+1-202-666-0124"}, "delivery": { "company":"", "address":"", "city":"", "postalCode":"", "stateProvince":"", "country":"", "zone":"", "firstName":"", "lastName":"" }, "emailAddress":"another@email.com", "groups":[], "language":"en", "userName":"" }
    When method put
    Then status <response_status>
    Then print response

    Examples:
      | customer_id  | response_status  |
      | -1           | 404              |
      | \'34\'       | 500              |
      | \'nonint\'   | 500              |
