*** Settings ***
Library    RequestsLibrary
Library    SeleniumLibrary
Library    Collections

*** Variables ***
${Base_URL}=    https://reqres.in
${Name}=    Lina
${Job}=    QA Automation

*** Test Cases ***
Post_Employeee_Regist
    [Documentation]  New employee registration
    Given a user access to the employee api
    When sends a POST request to register a new employee
    Then a new employee is created

*** Keywords ***
a user access to the employee api
    log to console  Accediendo a la api de empleados

sends a POST request to register a new employee
    Create session  mysession   ${Base_URL}    verify=true
    ${body}=    create dictionary  name=${Name} job=${Job}
    ${response}=    Post On Session  mysession    /api/users/    data=${body}
    Set Global Variable    ${response}

a new employee is created
    #VALIDATIONS
    log to console  ${response.status_code}
    log to console  ${response.content}
    ${status_code}=    convert to string  ${response.status_code}
    should be equal  ${status_code}    201
    ${res_body}=    convert to string   ${response.content}
    should contain  ${res_body}    ${Name}
    should contain  ${res_body}    ${Job}

    ${json_response}    Evaluate    json.loads('''${response.text}''')   json
    ${third_field}    Set Variable    ${json_response['id']}

    ${is_integer}    Evaluate    isinstance(${third_field}, int) and ${third_field} >= 0

    Run Keyword If    ${third_field}    Log    The value is an integer
    ...    ELSE    Log    The value is not an integer