*** Settings ***
Library    RequestsLibrary
Library    Collections
Library    DateTime

*** Variables ***
${URL_BASE}    https://restful-booker.herokuapp.com

*** Keywords ***
Step 1 - Fazer a Requisição
    ${response}=    GET    ${URL_BASE}/booking/87
    Log    Response Status: ${response.status_code}
    RETURN    ${response}

Step 2 - Validar Status Code
    [Arguments]    ${response}
    Should Be Equal As Numbers    ${response.status_code}    200

Step 3 - Armazenar Resposta JSON
    [Arguments]    ${response}
    ${json_response}=    Set Variable    ${response.json()}
    RETURN    ${json_response}

Step 4 - Validar Dados Pessoais
    [Arguments]    ${json_response}
    ${firstname}=    Get From Dictionary    ${json_response}    firstname
    Should Be Equal As Strings    ${firstname}    John

    ${lastname}=    Get From Dictionary    ${json_response}    lastname
    Should Be Equal As Strings    ${lastname}    Smith

Step 5 - Validar Preço e Pagamento
    [Arguments]    ${json_response}
    ${totalprice}=    Get From Dictionary    ${json_response}    totalprice
    Should Be Equal As Numbers    ${totalprice}    111

    ${depositpaid}=    Get From Dictionary    ${json_response}    depositpaid
    Should Be True    ${depositpaid}

Step 6 - Validar Datas de Reserva
    [Arguments]    ${json_response}
    Dictionary Should Contain Key    ${json_response}    bookingdates
    ${bookingdates}=    Get From Dictionary    ${json_response}    bookingdates

    Dictionary Should Contain Key    ${bookingdates}    checkin
    Dictionary Should Contain Key    ${bookingdates}    checkout

    ${checkin}=    Get From Dictionary    ${bookingdates}    checkin
    Should Match Regexp    ${checkin}    ^\\d{4}-\\d{2}-\\d{2}$

    ${checkout}=    Get From Dictionary    ${bookingdates}    checkout
    Should Match Regexp    ${checkout}    ^\\d{4}-\\d{2}-\\d{2}$

    ${checkin_date}=    Convert Date    ${checkin}    result_format=%Y-%m-%d
    ${checkout_date}=    Convert Date    ${checkout}    result_format=%Y-%m-%d
    Should Be True    '${checkin_date}' < '${checkout_date}'    A data de check-in deve ser anterior à check-out!

Step 7 - Validar Necessidades Adicionais
    [Arguments]    ${json_response}
    ${additionalneeds}=    Get From Dictionary    ${json_response}    additionalneeds
    Should Be Equal As Strings    ${additionalneeds}    Breakfast


*** Test Cases ***
Cenário 1: Consultar as reservas cadastradas com base em um ID
    ${response}=    Step 1 - Fazer a Requisição
    Step 2 - Validar Status Code    ${response}
    ${json_response}=    Step 3 - Armazenar Resposta JSON    ${response}
    Step 4 - Validar Dados Pessoais    ${json_response}
    Step 5 - Validar Preço e Pagamento    ${json_response}
    Step 6 - Validar Datas de Reserva    ${json_response}
    Step 7 - Validar Necessidades Adicionais    ${json_response}