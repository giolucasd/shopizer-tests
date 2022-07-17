Feature: H3

  Background:
    * def adminAuthResponse = call read('AdminAuth.feature')
    * def adminToken = adminAuthResponse.response.token
    * def createUserResponse = call read('CreateUser.feature')
    * def token = createUserResponse.response.token
    * url 'http://localhost:8080/api/v1'
    * header Authorization = 'Bearer ' + token

  Scenario: Test Creating Account (1 -> 2)

    * def now = function(){ return java.lang.System.currentTimeMillis() }
    * def email = 'email' + now() + '@test.com'
    Given path '/customer/register'
    And request {"userName":"#(email)","password":"p@ssw0rd","emailAddress":"#(email)","gender":"M","language":"en","billing":{"country":"CA","stateProvince":"QC","firstName":"John","lastName":"Doe"}}
    And method post
    Then status 200
    And print response

  Scenario: Log user with non-empty shoping cart and logout (2 -> 5 -> 2)
    # Product and Category setup
    * header Authorization = 'Bearer ' + adminToken
    * def cat = call read('CreateCategory.feature')
    * def prod1 = call read('CreateProduct.feature')
    Given url 'http://localhost:8080/api/v1/private/product/' + prod1.response.id + '/category/' + cat.response.id
    When method post
    Then status 201
    Then print prod1
    # Cart setup
    * header Authorization = 'Bearer ' + token
    * def sku = prod1.response.sku
    Given url 'http://localhost:8080/api/v1/cart/?store=DEFAULT'
    And request {"product":#(sku),"quantity":1}
    When method post
    Then status 201
    Then print response
    # Cart Test
    Given url 'http://localhost:8080/api/v1/cart/' + response.code + '?lang=en'
    When method get
    Then status 200
    Then assert response.products.length != 0
    Then print response
  
  Scenario: Log user with non-empty shoping cart, add item above limit and logout  (2 -> 5 -> 6 -> 2)
    # Product and Category setup
    * header Authorization = 'Bearer ' + adminToken
    * def cat = call read('CreateCategory.feature')
    * def prod1 = call read('CreateProduct.feature')
    Given url 'http://localhost:8080/api/v1/private/product/' + prod1.response.id + '/category/' + cat.response.id
    When method post
    Then status 201
    Then print prod1
    # Cart setup
    * header Authorization = 'Bearer ' + token
    * def sku = prod1.response.sku
    Given url 'http://localhost:8080/api/v1/cart/?store=DEFAULT'
    And request {"product":#(sku),"quantity":1}
    When method post
    Then status 201
    Then print response
    # Cart Test
    Given url 'http://localhost:8080/api/v1/cart/' + response.code + '?lang=en'
    And request {"product":#(sku),"quantity":10000}
    When method put
    Then assert responseStatus != 201
    Then print response
    Given url 'http://localhost:8080/api/v1/cart/' + response.code + '?lang=en'
    When method get
    Then status 200
    Then assert response.products.length != 0
    Then print response

 # Scenario: Login with invalid data, login user with non-empty shoping cart and logout (2 -> 3 -> 5 -> 2)
    # Product and Category setup
    * header Authorization = 'Bearer ' + adminToken
    * def cat = call read('CreateCategory.feature')
    * def prod1 = call read('CreateProduct.feature')
    Given url 'http://localhost:8080/api/v1/private/product/' + prod1.response.id + '/category/' + cat.response.id
    When method post
    Then status 201
    Then print prod1
    # User login error
    Given url 'http://localhost:8080/api/v1/customer/login/'
    And request {"username":"wrongUser","password":"p@ssw0rd"}
    When method post
    Then status 401
    Then print response
    # Cart setup
    * header Authorization = 'Bearer ' + token
    * def sku = prod1.response.sku
    Given url 'http://localhost:8080/api/v1/cart/?store=DEFAULT'
    And request {"product":#(sku),"quantity":1}
    When method post
    Then status 201
    Then print response
    # Cart Test
    Given url 'http://localhost:8080/api/v1/cart/' + response.code + '?lang=en'
    When method get
    Then status 200
    Then assert response.products.length != 0
    Then print response

  Scenario: Login user with empty shoping cart, add item to cart and logout (2 -> 4 -> 5 -> 2)
    # Product and Category setup
    * header Authorization = 'Bearer ' + adminToken
    * def cat = call read('CreateCategory.feature')
    * def prod1 = call read('CreateProduct.feature')
    Given url 'http://localhost:8080/api/v1/private/product/' + prod1.response.id + '/category/' + cat.response.id
    When method post
    Then status 201
    Then print prod1
    # Cart Test
    * header Authorization = 'Bearer ' + token
    * def sku = prod1.response.sku
    Given url 'http://localhost:8080/api/v1/cart/?store=DEFAULT'
    And request {"product":#(sku),"quantity":1}
    When method post
    Then status 201
    Then print response
    Given url 'http://localhost:8080/api/v1/cart/' + response.code + '?lang=en'
    When method get
    Then status 200
    Then assert response.products.length != 0
    Then print response

#  Scenario: Login with invalid data, login user with empty shoping cart, add item to cart and logout (2 -> 3 -> 4 -> 5 -> 2)
    # Product and Category setup
    * header Authorization = 'Bearer ' + adminToken
    * def cat = call read('CreateCategory.feature')
    * def prod1 = call read('CreateProduct.feature')
    Given url 'http://localhost:8080/api/v1/private/product/' + prod1.response.id + '/category/' + cat.response.id
    When method post
    Then status 201
    Then print prod1
    # User login error
    Given url 'http://localhost:8080/api/v1/customer/login/'
    And request {"username":"wrongUser","password":"p@ssw0rd"}
    When method post
    Then status 401
    Then print response
    # Cart Test
    * header Authorization = 'Bearer ' + token
    * def sku = prod1.response.sku
    Given url 'http://localhost:8080/api/v1/cart/?store=DEFAULT'
    And request {"product":#(sku),"quantity":1}
    When method post
    Then status 201
    Then print response
    Given url 'http://localhost:8080/api/v1/cart/' + response.code + '?lang=en'
    When method get
    Then status 200
    Then assert response.products.length != 0
    Then print response