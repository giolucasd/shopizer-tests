Feature: Create Customer API

  Background:
    * url 'http://localhost:8080/api/v1/private/customer/'
    * def token = "eyJhbGciOiJIUzUxMiJ9.eyJzdWIiOiJhZG1pbkBzaG9waXplci5jb20iLCJhdWQiOiJhcGkiLCJleHAiOjE2NTU3NDgwMzAsImlhdCI6MTY1NTE0MzIzMH0._eLqvlTQZHUqpwq8w6fcs2uiYYOC9yjjPdQD7F5OX118n4FhwCt6lzxVe7NEryXyxQoBzZMFlPERGCYcNGRTUg"
    * header Authorization = 'Bearer ' + token

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
    Then status <response_status>
    Then print response

    Examples:
      | read('post-entries.csv') |