*** Settings ***
Library    RequestsLibrary
Library    Collections
Library    DateTime
Library    String

*** Variables ***
${URL_BASE}    https://restful-booker.herokuapp.com

*** Keywords ***

Step 1: Criar dados da reserva
    ${bookingdates}=    Create Dictionary    checkin=2018-01-01    checkout=2019-01-01
    ${data}=    Create Dictionary    firstname=Michael    lastname=Felipe    totalprice=4000    depositpaid=True    bookingdates=${bookingdates}    additionalneeds=Dinner
    Log    Dados da reserva: ${data}
    RETURN    ${data}

Step 2: Enviar requisição POST
    [Arguments]    ${data}
    ${response}=    POST    ${URL_BASE}/booking    json=${data}
    Log    Response Status: ${response.status_code}
    Log    Response Body: ${response.text}
    Log    ${response.reason}
    RETURN    ${response}

Step 3: Validar resposta da requisição
    [Arguments]    ${response}
    Should Be True    ${response.ok}
    Should Be Equal As Numbers    ${response.status_code}    200


    ${booking}     Set Variable    ${response.json()}
    Log Dictionary    ${booking}
    
    
    ${bookinginfo}=    Get From Dictionary    ${booking}    booking
    Should Be Equal As Strings    ${bookinginfo['firstname']}    Michael
    Should Be Equal As Strings    ${bookinginfo['lastname']}    Felipe
    Should Be Equal As Numbers    ${bookinginfo['totalprice']}    4000
    Should Be Equal As Strings    ${bookinginfo['additionalneeds']}  Dinner




*** Test Cases ***
Cenário: Cadastrar uma reserva
    ${data}=    Step 1: Criar dados da reserva
    ${response}=    Step 2: Enviar requisição POST    ${data}
    Step 3: Validar resposta da requisição    ${response}            
