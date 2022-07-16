Feature: H4

  Background:
    Given url 'http://localhost:8080/api/v1'

  Scenario: Test Creating Account (1 -> 2)

    Given path '/customer/register'
    And request {"userName":"email@test.com","password":"p@ssw0rd","emailAddress":"email@test.com","gender":"M","language":"en","billing":{"country":"CA","stateProvince":"QC","firstName":"John","lastName":"Doe"}}
    And method post
    Then status 200
    And print response

  Scenario: 2 -> 6 -> 10 -> 2
    # 1. Create products for testing
    # 2. Create user and add products to user cart
    # 3. Login user
    # 4. Try to add more of an item than its possible
    # 5. Check message not allowing it
    # 6. Logout
  
  Scenario: 2 -> 6 -> 8 -> 9 -> 2
    # 1. Create products for testing
    # 2. Create user and add products to user cart
    # 3. Login user
    # 4. Calculate purchase price
    # 5. Pay purchase
    # 6. Logout

  Scenario: 2 -> 6 -> 8 -> 7 -> 2
    # 1. Create products for testing
    # 2. Create user and add products to user cart
    # 3. Login user
    # 4. Calculate purchase price
    # 5. Cancel purchase
    # 6. Logout

  Scenario: 2 -> 3 -> 6 -> 2
    # 1. Create products for testing
    # 2. Create user and add products to user cart
    # 3. Try logjn with invalid data
    # 4. Check login denied
    # 5. Login user
    # 6. Logout

  Scenario: 2 -> 5 -> 6 -> 2
    # 1. Create products for testing
    # 2. Create user
    # 3. Login user
    # 4. Add items to user cart
    # 5. Logout

  Scenario: 2 -> 6 -> 5 -> 4 -> 2
    # 1. Create products for testing
    # 2. Create user and add items to his cart
    # 3. Login user
    # 4. Remove all items from user cart
    # 5. Calculate purchase value for empty purchase
    # 6. Logout