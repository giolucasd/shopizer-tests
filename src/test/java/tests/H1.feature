Feature: Get Customer API

  Background:
    Given url 'http://localhost:8080/api/v1'

  Scenario: Test Creating Repeated Account (1 -> 2 -> 3)

    Given path '/customer/register'
    And request {"userName":"email@test.com","password":"p@ssw0rd","emailAddress":"email@test.com","gender":"M","language":"en","billing":{"country":"CA","stateProvince":"QC","firstName":"John","lastName":"Doe"}}
    And method post
    Then status 200
    And print response
    When path '/customer/register'
    And request {"userName":"email@test.com","password":"p@ssw0rd","emailAddress":"email@test.com","gender":"M","language":"en","billing":{"country":"CA","stateProvince":"QC","firstName":"John","lastName":"Doe"}}
    And method post
    Then status 500
    And print response

  Scenario: Validate User Data (2 -> 4 -> 7)

    Given path '/customer/login/'
    And request {"username":"email@test.com","password":"p@ssw0rd"}
    And method post
    Then status 200
    And def token = response.token
    And print response
    When path '/auth/customer/profile'
    And header Authorization = 'Bearer ' + token
    And method get
    Then status 200
    And response.emailAddress = "email@test.com"
    And response.firstName = "John"
    And response.lastName = "Doe"
    And response.billing.country = "CA"
    And print response

  Scenario: Test Empty Order List (2 -> 4 -> 5)

    Given path '/customer/login/'
    And request {"username":"email@test.com","password":"p@ssw0rd"}
    And method post
    Then status 200
    And def token = response.token
    And print response
    When path '/auth/orders'
    And header Authorization = 'Bearer ' + token
    And method get
    Then status 200
    And response.orders = null
    And print response

  Scenario: Test Empty Order List (2 -> 4 -> 6)

    Given path '/customer/login/'
    And request {"username":"email@test.com","password":"p@ssw0rd"}
    And method post
    Then status 200
    And def token = response.token
    And print response
    When path '/customer/password'
    And header Authorization = 'Bearer ' + token
    And request {"password":"n3wp@ssw0rd","repeatPassword":"n3wp@ssw0rd","current":"p@ssw0rd","username":"email@test.com"}
    And method post
    Then status 200
    And print response