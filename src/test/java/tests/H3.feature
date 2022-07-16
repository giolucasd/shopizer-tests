Feature: H3

  Background:
    Given url 'http://localhost:8080/api/v1'

  Scenario: Test Creating Account (1 -> 2)

    Given path '/customer/register'
    And request {"userName":"email@test.com","password":"p@ssw0rd","emailAddress":"email@test.com","gender":"M","language":"en","billing":{"country":"CA","stateProvince":"QC","firstName":"John","lastName":"Doe"}}
    And method post
    Then status 200
    And print response

  Scenario: Log user with non-empty shoping cart and logout (2 -> 5 -> 2)
    # 1. Create products for testing
    # 2. Create user and add products to user cart
    # 3. Login user
    # 4. Hit API to get items ordered by price
    # 5. Check if the order actually is ordered by price
    # 6. Logout
  
  Scenario: Log user with non-empty shoping cart, add item above limit and logout  (2 -> 5 -> 6 -> 2)
    # 1. Create products for testing
    # 2. Create user and add products to user cart
    # 3. Login user
    # 4. Hit API to get items ordered by price
    # 5. Check if the order actually is ordered by price
    # 6. Try to add too many of an item
    # 7. Check message not allowing it
    # 8. Logout

  Scenario: Login with invalid data, login user with non-empty shoping cart and logout (2 -> 3 -> 5 -> 2)
    # 1. Create products for testing
    # 2. Create user and add products to user cart
    # 3. Try to login with invalid data and check denied
    # 4. Login user
    # 5. Hit API to get items ordered by price
    # 6. Check if the order actually is ordered by price
    # 7. Logout

  Scenario: Login user with empty shoping cart, add item to cart and logout (2 -> 4 -> 5 -> 2)
    # 1. Create products for testing
    # 2. Create user
    # 3. Login user
    # 4. Add item to user cart
    # 5. Hit API to get items ordered by price
    # 6. Check if the order actually is ordered by price
    # 7. Logout

  Scenario: Login with invalid data, login user with empty shoping cart, add item to cart and logout (2 -> 3 -> 4 -> 5 -> 2)
    # 1. Create products for testing
    # 2. Create user
    # 3. Try to login with invalid data and check denied
    # 4. Login user
    # 5. Add item to user cart
    # 6. Hit API to get items ordered by price
    # 7. Check if the order actually is ordered by price
    # 8. Logout