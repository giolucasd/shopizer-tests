Feature: H2

  Background:
    * def adminAuthResponse = call read('AdminAuth.feature')
    * def adminToken = adminAuthResponse.response.token
    * def createUserResponse = call read('CreateUser.feature')
    * def token = createUserResponse.response.token
    * url 'http://localhost:8080/api/v1'
    * header Authorization = 'Bearer ' + token

  Scenario: Test 1 (2 -> 4 -> 7)
    #Usuário cadastrado e logado no 'Background'
    * header Authorization = 'Bearer ' + adminToken
    * def cat = call read('CreateCategory.feature')
    * def prod1 = call read('CreateProduct.feature')
    * def prod2 = call read('CreateProductRandPrice.feature')
    Given url 'http://localhost:8080/api/v1/private/product/' + prod1.response.id + '/category/' + cat.response.id
    When method post
    Then status 201
    Given url 'http://localhost:8080/api/v1/private/product/' + prod2.response.id + '/category/' + cat.response.id
    When method post
    Then status 201
    # Context Setup
    * header Authorization = 'Bearer ' + token
    Given url 'http://localhost:8080/api/v1/products/?&store=DEFAULT&lang=en&page=0&count=15&category=' + cat.response.id
    When method get
    Then status 200
    Then assert response.products.length == 2
    Then assert response.products[0].finalPrice != response.products[1].finalPrice
    Then print response

  Scenario: Test 2 (2 -> 4 -> 5)
    #Usuário cadastrado e logado no 'Background'
    * header Authorization = 'Bearer ' + adminToken
    * def cat = call read('CreateCategory.feature')
    # Context Setup
    * header Authorization = 'Bearer ' + token
    Given url 'http://localhost:8080/api/v1/products/?&store=DEFAULT&lang=en&page=0&count=15&category=' + cat.response.id
    When method get
    Then status 200
    Then assert response.products.length == 0
    Then print response

  Scenario: Test 3 (2 -> 4 -> 6)
    #Usuário cadastrado e logado no 'Background'
    * header Authorization = 'Bearer ' + adminToken
    * def cat = call read('CreateCategory.feature')
    * def prod1 = call read('CreateProduct.feature')
    * def prod2 = call read('CreateProduct.feature')
    Given url 'http://localhost:8080/api/v1/private/product/' + prod1.response.id + '/category/' + cat.response.id
    When method post
    Then status 201
    Given url 'http://localhost:8080/api/v1/private/product/' + prod2.response.id + '/category/' + cat.response.id
    When method post
    Then status 201
    # Context Setup
    * header Authorization = 'Bearer ' + token
    Given url 'http://localhost:8080/api/v1/products/?&store=DEFAULT&lang=en&page=0&count=15&category=' + cat.response.id
    When method get
    Then status 200
    Then assert response.products.length == 2
    Then assert response.products[0].finalPrice == response.products[1].finalPrice
    Then print response

  Scenario: Test 4 (1 -> 2 -> 3)
    # Usuário não cadastrado
    Given call read('CreateUser.feature')
    # Usuário cadastrado
    Given path '/customer/login/'
    And request {"username":"wrongUser","password":"p@ssw0rd"}
    When method post
    Then status 401
    Then print response