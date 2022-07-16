Feature: Create Category API

  Background:
    * def now = function(){ return java.lang.System.currentTimeMillis() }
    * def code = now()
    * def adminAuthResponse = call read('AdminAuth.feature')
    * def token = adminAuthResponse.response.token
    * url 'http://localhost:8080/api/v1/private/category'
    * header Authorization = 'Bearer ' + token

  Scenario: Create Category Step.

    Given path '/'
    And request {"parent":{"id":0,"code":"root"},"store":"DEFAULT","visible":true,"code":"#(code)","sortOrder":0,"selectedLanguage":"en","descriptions":[{"language":"en","name":"Refrigerator","highlights":"","friendlyUrl":"refrigerator","description":"Refrigerator Category","title":"","metaDescription":""}]}
    And method post
    Then status 201
    And print response