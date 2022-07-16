Feature: Create Product API

  Background:
    * def now = function(){ return java.lang.System.currentTimeMillis() }
    * def id = now()
    * def adminAuthResponse = call read('AdminAuth.feature')
    * def token = adminAuthResponse.response.token
    * url 'http://localhost:8080/api/v2/private/product/definition?store=DEFAULT'
    * header Authorization = 'Bearer ' + token

  Scenario: Create Product Step.

    Given path '/'
    And request {"identifier":"#(id)","visible":true,"dateAvailable":"2022-07-15","manufacturer":"DEFAULT","type":"","display":true,"canBePurchased":true,"timeBound":false,"price":125,"quantity":2,"sortOrder":"2","productSpecifications":{"weight":"","height":"","width":"","length":""},"descriptions":[{"language":"en","name":"Product Name","highlights":"","friendlyUrl":"product-name","description":"Product Description","title":"getMerchantName(){return localStorage.getItem(\"merchant\")} | Product Name","keyWords":"","metaDescription":""}]}
    And method post
    Then status 201
    And print response