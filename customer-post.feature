Feature: Create Customer API

  Background:
    * url 'https://localhost/api/v1/private/customer/'

  Scenario Outline: Test arguments domain.

    Given path '/<customer_id>'
    And request {
        "billing": {
            "company":"",
            "address":<billing_address>,
            "city":<billing_city>,
            "postalCode":<billing_postalCode>,
            "stateProvince":<billing_stateProvince>,
            "country":<billing_country>,
            "zone":<billing_zone>,
            "firstName":<billing_firstName>,
            "lastName":<billing_lastName>,
            "phone":<billing_phone>
        },
        "delivery": {
            "company":"",
            "address":"",
            "city":"",
            "postalCode":"",
            "stateProvince":"",
            "country":"",
            "zone":"",
            "firstName":"",
            "lastName":""
        },
        "emailAddress":<emailAddress>,
        "groups":[],
        "language":"en",
        "userName":""
    }
    When method post
    Then status response_status
    Then print response

    Examples:
      | read('post-entries.csv') |