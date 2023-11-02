*** Settings ***
Resource    ../resources/api_testing_users.resource

*** Variables ***
 

*** Test Cases ***
Scenario 01: Successfully register new user
    Create new user
    Register user on ServeRest    email=${EMAIL_TEST}    status_code_expected=201
    Check if user was successfully created

Scenario 02: Register existing user
    Create new user
    Register user on ServeRest    email=${EMAIL_TEST}    status_code_expected=201
    Repeat same register
    Check if the API did not allow repeated registration

Scenario 03: Get new user by _id
    Create new user
    Register user on ServeRest    email=${EMAIL_TEST}    status_code_expected=201
    Get new user data
    Check new user data
