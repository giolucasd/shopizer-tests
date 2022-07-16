Feature: Create Customer

  Background:
    * def now = function(){ return java.lang.System.currentTimeMillis() }
    * def email = 'email' + now() + '@test.com'
    Given url 'http://localhost:8080/api/v1'

  Scenario: Create Customer Step.

    Given path '/customer/register'
    And request {"userName":"#(email)","password":"p@ssw0rd","emailAddress":"#(email)","gender":"M","language":"en","billing":{"country":"CA","stateProvince":"QC","firstName":"John","lastName":"Doe"}}
    And method post
    Then status 200
    And print response