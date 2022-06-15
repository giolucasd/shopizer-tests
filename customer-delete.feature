Feature: Delete Customer API

  Background:
    * url 'https://localhost/api/v1/private/customer/'

  Scenario Outline: Test ID domain.

    Given path '/<customer_id>'
    And request {id: <customer_id>}
    When method delete
    Then status response_status
    Then print response

    Examples:
      | customer_id | response_status  |
      | 35          | 200              |
      | '35'        | 204              |
      | 'nonint'    | 204              |