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
    Create session  mysession   ${Base_URL}    verify=true
    ${body}=    create dictionary  name=${Name} job=${Job}
    ${response}=    Post On Session  mysession    /api/users/    data=${body}

    log to console  ${response.status_code}
    log to console  ${response.content}

    #VALIDATIONS
    ${status_code}=    convert to string  ${response.status_code}
    should be equal  ${status_code}    201

    ${res_body}=    convert to string   ${response.content}
    should contain  ${res_body}    ${Name}
    should contain  ${res_body}    ${Job}