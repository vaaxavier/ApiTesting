*** Settings ***
Library    RequestsLibrary
Library    String
Library    Collections

*** Keywords ***

Create session on ServeRest
    ${headers}    Create Dictionary    accept=application/json    Content-Type=application/json
    Create Session    alias=ServeRest    url=https://serverest.dev    headers=${headers}
Create new user
    ${random_email}    Generate Random String    length=4    chars=[LETTERS]
    ${random_email}    Convert To Lower Case    ${random_email}
    Set Test Variable    ${EMAIL_TEST}    valeria.xavier+${random_email}@teapayment.co.uk
    Log  ${EMAIL_TEST}

Register user on ServeRest
    [Arguments]    ${email}    ${status_code_expected}
    ${body}    Create Dictionary
    ...    nome=Fulano da Silva
    ...    email=${EMAIL_TEST}
    ...    password=1234
    ...    administrador=true
    Log    ${body}
    Create session on ServeRest

    ${resposta}    POST On Session
    ...    alias=ServeRest
    ...    url=/usuarios
    ...    json=${body}
    ...    expected_status=${status_code_expected}
    
    Log    ${resposta.json()}
    IF     ${resposta.status_code} == 201
        Set Test Variable    ${USER_ID}    ${resposta.json()["_id"]}
    END
    
    Set Test Variable    ${RESPOSTA}    ${resposta.json()}

Check if user was successfully created
    Log    ${RESPOSTA}
    Dictionary Should Contain Item    ${RESPOSTA}    message    Cadastro realizado com sucesso
    Dictionary Should Contain Key    ${RESPOSTA}    _id

Repeat same register
    Register user on ServeRest    email=${EMAIL_TEST}    status_code_expected=400

Check if the API did not allow repeated registration 
    Dictionary Should Contain Item    ${RESPOSTA}    message    Este email já está sendo usado
    Dictionary Should Not Contain Key    ${RESPOSTA}    _id_

Get new user data
    ${resposta_consulta}    GET On Session    alias=ServeRest    url=/usuarios/${USER_ID}    expected_status=200
    Set Test Variable    ${RESP_CONSULTA}    ${resposta_consulta.json()}
Check new user data
    Log    ${RESP_CONSULTA}
    Dictionary Should Contain Item    ${RESP_CONSULTA}    nome             Fulano da Silva
    Dictionary Should Contain Item    ${RESP_CONSULTA}    email            ${EMAIL_TEST}
    Dictionary Should Contain Item    ${RESP_CONSULTA}    password         1234
    Dictionary Should Contain Item    ${RESP_CONSULTA}    administrador    true
    Dictionary Should Contain Item    ${RESP_CONSULTA}    _id              ${USER_ID}