*** Settings ***
Library           RequestsLibrary
Library           Collections

*** Variables ***

${BASE_URL}       https://restful-booker.herokuapp.com

*** Test Cases ***
Gerando um token

    ${data}=    Create Dictionary    username=admin    password=password123
    # Enviando a solicitação POST
    ${response}=    POST    ${BASE_URL}/auth    json=${data}
    Should Be True    ${response.ok}
    Should Be Equal As Numbers    ${response.status_code}    200
    # Validando os valores retornados e formatando para json
    ${data_response}=    Set Variable    ${response.json()}
    # Capturando o token gerado
    ${token}=    Get From Dictionary    ${data_response}    token
    Log  Seu token é:${token}