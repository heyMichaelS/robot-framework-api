*** Settings ***
Library    RequestsLibrary

*** Variables ***
${URL_BASE}    https://restful-booker.herokuapp.com

*** Keywords ***


Step 1: Fazer uma request GET para a URL
    ${response}=    GET    ${URL_BASE}/booking
    Log    Response Status: ${response.status_code}
    Log    Response Body: ${response.text}
    [Return]    ${response}

Step 2: Validar status da resposta
    [Arguments]    ${response}
    Status Should Be    200    ${response}

Step 3: Validar corpo da resposta
    [Arguments]    ${response}
    ${response_json}=    Evaluate    json.loads($response.text)    json
    Should Not Be Empty    ${response_json}    A resposta não pode ser vazia!

*** Test Cases ***
Cenário 1: Fazer uma request GET e validar resposta
    ${response}=    Step 1: Fazer uma request GET para a URL
    Step 2: Validar status da resposta    ${response}
    Step 3: Validar corpo da resposta    ${response}
