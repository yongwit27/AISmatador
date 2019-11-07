*** Settings ***
Resource          ../Repository/Repository.robot
Resource          ../Variable/LocalConfig.robot
Resource          RedefineKeywords.robot

*** Keywords ***
Login
    [Arguments]    ${username}    ${password}
    Comment    Click Web Element    ${btnIDSSignin}
    Input Web Text    ${fieldUsername}    ${username}
    Input Web Text    ${fieldPassword}    ${password}
    Click Web Element    ${btnSubmit}

Input Task
    [Arguments]    ${date}    ${TaskDescription}    ${TaskType}    ${TaskDuration}    &{task}    # ${date} | ${task} | ${type} | ${duration} | ${pop}
    Click Web Element    ${btnDate}    ${date}
    Click Web Element    ${btnAddTask}
    Input Web Text    ${fieldTaskDescription}    ${TaskDescription}
    Select From Web List By Label    ${listDuration}    ${TaskDuration}
    :FOR    ${key}    IN    @{task}
    \    ${value}    Set Variable    ${task['${key}']}
    \    ${key}    Convert To Uppercase    ${key}
    \    Run Keyword If    '${key}' == 'PROJECT'    Input Project    ${fieldProjectOfPOP}    ${value}
    \    ...    ELSE IF    '${key}' == 'FEATURE'    Select From Web List By Label    ${listFeature}    ${value}
    \    ...    ELSE    log
    Click Web Element    ${listTypeOfTask}
    Select From Web List By Label    ${listTypeOfTask}    ${TaskType}
    Click Web Element    ${btnSave}
    Web Element Should Be Not Visible    ${btnSave}

Delete Task
    ${count}    Selenium2Library.Get Element Count    ${btnHolidayDate}
    : FOR    ${i}    IN RANGE    1    ${count}
    \    Click Web Element    ${btnHolidayDate}    ${i}
    \    ${status}    Run Keyword And Return Status    Web Element Should Be Visible    ${btnTrash}
    \    Run Keyword If    '${status}' == \ 'True'    Run Keywords    Click Web Element    ${btnTrash}
    \    ...    AND    Click Web Element    ${btnOK}
    \    ...    AND    Wait Until Element Is Not Visible    ${btnOK}
    \    ...    ELSE IF    '${status}' \ == 'False'    Click Web Element    //button[@Class='close']

Input Project
    [Arguments]    ${locator}    ${value}
    Input Web Text    ${locator}    ${value}
    Press Key    ${locator}    \\13
