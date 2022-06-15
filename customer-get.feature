Feature: Get Customer API

  Background:
    * url 'http://localhost:8080/api/v1/private/customer/'
    * def token = "eyJhbGciOiJIUzUxMiJ9.eyJzdWIiOiJhZG1pbkBzaG9waXplci5jb20iLCJhdWQiOiJhcGkiLCJleHAiOjE2NTU3NDgwMzAsImlhdCI6MTY1NTE0MzIzMH0._eLqvlTQZHUqpwq8w6fcs2uiYYOC9yjjPdQD7F5OX118n4FhwCt6lzxVe7NEryXyxQoBzZMFlPERGCYcNGRTUg"

  Scenario Outline: Test ID domain.

    Given path '/<customer_id>'
    And header Authorization = 'Bearer ' + token
    And request {id: <customer_id>}
    When method get
    Then status <response_status>
    Then print response

    Examples:
      | customer_id | response_status  |
      | 1          | 200              |
      | \'35\'        | 500              |
      | \'nonint\'    | 500              |
