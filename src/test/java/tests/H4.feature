Feature: H4

  Background:
    * def adminAuthResponse = call read('AdminAuth.feature')
    * def adminToken = adminAuthResponse.response.token
    * url 'http://localhost:8080/api/v1'

  Scenario: Test Creating Account (1 -> 2)

    * def now = function(){ return java.lang.System.currentTimeMillis() }
    * def email = 'email' + now() + '@test.com'
    Given path '/customer/register'
    And request {"userName":"#(email)","password":"p@ssw0rd","emailAddress":"#(email)","gender":"M","language":"en","billing":{"country":"CA","stateProvince":"QC","firstName":"John","lastName":"Doe"}}
    And method post
    Then status 200
    And print response

  Scenario: Test Add Non-available Quantity to Cart (2 -> 6 -> 10 -> 2)
    # 1. Create products for testing
    * header Authorization = 'Bearer ' + adminToken
    * def cat = call read('CreateCategory.feature')
    * def prod1 = call read('CreateProduct.feature')
    Given url 'http://localhost:8080/api/v1/private/product/' + prod1.response.id + '/category/' + cat.response.id
    When method post
    Then status 201
    Then print prod1

    # 2. Create user and add products to user cart
    * def createUserResponse = call read('CreateUser.feature')
    * def token = createUserResponse.response.token
    * header Authorization = 'Bearer ' + token
    * def sku = prod1.response.sku
    Given url 'http://localhost:8080/api/v1/cart/?store=DEFAULT'
    And request {"product":#(sku),"quantity":1}
    When method post
    Then status 201
    Then print response

    # 3. Login user
    # token already created

    # 4. Try to add more of an item than its possible
    Given url 'http://localhost:8080/api/v1/cart/' + response.code + '?lang=en'
    And request {"product":#(sku),"quantity":10000}
    When method put

    # 5. Check message not allowing it
    Then assert responseStatus != 201
    Then print response

    # 6. Logout
    # no logout endpoint
  
  Scenario: Test Proceed with Purchase to Payment (2 -> 6 -> 8 -> 9 -> 2)
    # 1. Create products for testing
    * header Authorization = 'Bearer ' + adminToken
    * def cat = call read('CreateCategory.feature')
    * def prod1 = call read('CreateProduct.feature')
    Given url 'http://localhost:8080/api/v1/private/product/' + prod1.response.id + '/category/' + cat.response.id
    When method post
    Then status 201
    Then print prod1

    # 2. Create user and add products to user cart
    * def createUserResponse = call read('CreateUser.feature')
    * def token = createUserResponse.response.token
    * header Authorization = 'Bearer ' + token
    * def sku = prod1.response.sku
    Given url 'http://localhost:8080/api/v1/cart/?store=DEFAULT'
    And request {"product":#(sku),"quantity":1}
    When method post
    Then status 201
    Then print response
    * def cartCode = response.code

    # 3. Login user
    # token already created

    # 4. Calculate purchase price
    Given url 'http://localhost:8080/api/v1/cart/' + cartCode + '/total?lang=en'
    When method get
    Then status 200
    And response.totals[1].title = 'Total'
    And response.totals[1].value > 0
    And print response

    # 5. Pay purchase
    # TODO não to conseguindo descobrir como fazer isso funcionar. A interface do frontend não chega a chamar essa API.
    Given url 'http://localhost:8080/api/v1/cart/' + cartCode + '/payment/init?lang=en'
    * def amount = response.totals[1].value
    And request { "amount": #(amount), "paymentModule": "", "paymentToken": "", "paymentType": "CREDITCARD", "transactionType": "INIT" }
    When method post

    # 6. Logout
    # no logout endpoint

  Scenario: Test Cancel Purchase (2 -> 6 -> 8 -> 7 -> 2) or Test Login with Items in Cart then Delete Items (2 -> 6 -> 5 -> 4 -> 2)
    # 1. Create products for testing
    * header Authorization = 'Bearer ' + adminToken
    * def cat = call read('CreateCategory.feature')
    * def prod1 = call read('CreateProduct.feature')
    Given url 'http://localhost:8080/api/v1/private/product/' + prod1.response.id + '/category/' + cat.response.id
    When method post
    Then status 201
    Then print prod1

    # 2. Create user and add products to user cart
    * def createUserResponse = call read('CreateUser.feature')
    * def token = createUserResponse.response.token
    * header Authorization = 'Bearer ' + token
    * def sku = prod1.response.sku
    Given url 'http://localhost:8080/api/v1/cart/?store=DEFAULT'
    And request {"product":#(sku),"quantity":1}
    When method post
    Then status 201
    Then print response
    * def cartCode = response.code
    * def productId = response.products[0].id

    # 3. Login user
    # token already created

    # 4. Calculate purchase price
    Given url 'http://localhost:8080/api/v1/cart/' + cartCode + '/total?lang=en'
    When method get
    Then status 200
    And response.totals[1].title = 'Total'
    And response.totals[1].value > 0
    And print response

    # 5. Cancel purchase
    Given url 'http://localhost:8080/api/v1/cart/' + cartCode + '/product/' + productId + '?store=DEFAULT'
    When method delete
    Then status 204
    And print response
    Given url 'http://localhost:8080/api/v1/cart/' + cartCode + '?lang=en'
    When method get
    Then status 200
    Then assert response.products.length = 0
    Then print response

    # 6. Logout
    # no logout endpoint

  Scenario: Test Log In with Invalid User Then Log In with Valid User with Items in Cart (2 -> 3 -> 6 -> 2)
    # 1. Create products for testing
    * header Authorization = 'Bearer ' + adminToken
    * def cat = call read('CreateCategory.feature')
    * def prod1 = call read('CreateProduct.feature')
    Given url 'http://localhost:8080/api/v1/private/product/' + prod1.response.id + '/category/' + cat.response.id
    When method post
    Then status 201
    Then print response

    # 2. Create user and add products to user cart
    * def createUserResponse = call read('CreateUser.feature')
    * def token = createUserResponse.response.token
    * header Authorization = 'Bearer ' + token
    * def sku = prod1.response.sku
    Given url 'http://localhost:8080/api/v1/cart/?store=DEFAULT'
    And request {"product":#(sku),"quantity":1}
    When method post
    Then status 201
    Then print response
    * def cartCode = response.code

    # 3. Try login with invalid data
    Given url 'http://localhost:8080/api/v1/customer/login/'
    And request {"username":"wrongUser","password":"p@ssw0rd"}
    When method post

    # 4. Check login denied
    Then status 401
    Then print response

    # 5. Login user
    # token already created

    # 6. Check that cart is not empty
    Given url 'http://localhost:8080/api/v1/cart/' + cartCode + '?lang=en'
    When method get
    Then status 200
    Then assert response.products.length != 0
    Then print response

    # 6. Logout
    # no logout endpoint

  Scenario: Test Create User with Empty Cart then Add Items to Cart (2 -> 5 -> 6 -> 2)
    # 1. Create products for testing
    * header Authorization = 'Bearer ' + adminToken
    * def cat = call read('CreateCategory.feature')
    * def prod1 = call read('CreateProduct.feature')
    Given url 'http://localhost:8080/api/v1/private/product/' + prod1.response.id + '/category/' + cat.response.id
    When method post
    Then status 201
    Then print response
    * def sku = prod1.response.sku

    # 2. Create user and log in
    * def createUserResponse = call read('CreateUser.feature')
    * def token = createUserResponse.response.token
    * header Authorization = 'Bearer ' + token

    # 3. Check that cart is empty
    # TODO por algum motivo tá retornando 403 ao invés de 404, que seria o correto. Quando eu tento replicar a mesma chamada no Postman ou crio um teste aqui usando um token já criado, retorna 404.
    Given url 'http://localhost:8080/api/v1/'
    And path 'auth/customer/cart'
    And param lang = 'en'
    When method get
    Then status 404
    And print response

    # 4. Add items to user
    Given url 'http://localhost:8080/api/v1/cart/?store=DEFAULT'
    And request {"product":#(sku),"quantity":1}
    When method post
    Then status 201
    Then print response
    * def cartCode = response.code

    # 5. Check that cart is not empty
    Given url 'http://localhost:8080/api/v1/cart/' + cartCode + '?lang=en'
    When method get
    Then status 200
    And assert response.products.length != 0
    And print response

    # 5. Logout
    # no logout endpoint