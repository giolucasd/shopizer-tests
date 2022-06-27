Feature: Auth API

  Scenario: Test admin auth.
    Given url 'http://localhost:8080/api/v1/private/login'
    And request {"password": "password", "username": "admin@shopizer.com"}
    When method post
    Then status 200
    And print response
