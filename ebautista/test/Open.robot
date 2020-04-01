*** Settings ***
Resource            ../resource/Setup.robot
Resource            ../resource/Utilities.robot
Suite Setup         Open Initial Random Page
Suite Teardown      Close Browsers

*** Variables ***

*** Test Cases ***
Loof for Jesus Wiki Page
    ${VISITED_URLS}    Create List
    ${CURRENT_URL}=     Get Location
    Append To List      ${VISITED_URLS}     ${CURRENT_URL}
    Wait Until Element is Visible    xpath=${WIKI_LOGO_XPATH}
    FOR    ${INDEX}    IN RANGE     0    ${${NUMBER_OF_LOOPS}}
    \   ${RESULT}=    Am I In Heaven
    \   Run Keyword If   "${RESULT}" == "FALSE"   Expand Collapsed Sections
    \   ${RESULT}=    Run Keyword If   "${RESULT}" == "FALSE"   Look For Jesus
    \   ${HINT}=    Run Keyword If   "${RESULT}" == "FALSE"     Get Valid Link From Page
    \   Run Keyword If   "${HINT}" == "FALSE"   Click on Random Link
    \   ${CURRENT_URL}=     Get Location
    \   Append To List      ${VISITED_URLS}     ${CURRENT_URL}
    \   Run Keyword If   "${RESULT}" == "TRUE"  Exit For Loop
    Log List    ${VISITED_URLS}
