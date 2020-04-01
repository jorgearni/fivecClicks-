*** Settings ***
Library             BuiltIn
Library             String
Library             Collections

*** Variables ***

*** Keywords ***
Get Valid Link From Page
    [Return]    ${HINT}
    ${LINKS_IN_PAGE}=    Get Element Count    xpath=${LINK_XPATH}
    ${LINKS_IN_PAGE}=   Evaluate    ${LINKS_IN_PAGE} + 1
    FOR    ${INDEX}    IN RANGE     1    ${LINKS_IN_PAGE}
    \    ${URL}=    Get Text    xpath=(${LINK_XPATH})[${INDEX}]
    \    ${URL}=    Remove String    ${URL.strip()}    "
    \    ${URL}=    Replace String  ${URL}  \n  ${SPACE}
    \    ${URL}=    Convert To Lowercase    ${URL}
    \    ${HINT}=   Run Keyword If    "${URL}" != "${EMPTY}"    Filter Links  ${URL}    ELSE    Set Variable    FALSE
    \    Run Keyword If     "${HINT}" == "TRUE"     Go To   xpath=(${LINK_XPATH})[${INDEX}]
    \    Run Keyword If     "${HINT}" == "TRUE"     Exit For Loop

Am I In Heaven
    [Return]    ${RESULT}
    ${CURRENT_RUL}=    Get Location
    ${RESULT}=    Set Variable If    "${CURRENT_RUL}" == "${JESUS_URL}"    TRUE    FALSE

Look For Jesus
    [Return]    ${DOES_LINK_EXIST}
    ${COUNT}=    Get Element Count    xpath=${JESUS_WIKI}
    ${DOES_LINK_EXIST}=    Set Variable If    ${COUNT} > 0    TRUE    FALSE
    Run Keyword If    "${DOES_LINK_EXIST}" == "TRUE"    Go To   xpath=${JESUS_WIKI}

Filter Links
    [Arguments]    ${LINK}
    [Return]    ${RETURN_VALUE}
    ${RETURN_VALUE}     Set Variable    FALSE
    ${LENGTH}=      Get Length      ${CATHOLIC_PAGES}
    FOR    ${INDEX}    IN RANGE     0    ${LENGTH}
    #\   Log     @{CATHOLIC_PAGES}[${INDEX}]
    \   ${VALUE}    Run Keyword And Return Status   Should Match Regexp  ${LINK}     \\b@{CATHOLIC_PAGES}[${INDEX}]\\b
    \   ${RETURN_VALUE}  Set Variable If     '${VALUE}' == 'True'    TRUE    FALSE
    \   Run Keyword If    '${RETURN_VALUE}' == 'TRUE'   Exit For Loop

Click on Random Link
    ${LINKS_IN_PAGE}=   Get Element Count    xpath=${LINK_XPATH}
    ${LINKS_IN_PAGE}=   Evaluate    ${LINKS_IN_PAGE} + 1
    FOR     ${INDEX}    IN RANGE     0    ${NUMBER_OF_LOOPS_RANDOM_CLICK}
    \   ${RANDOM_NUMBER}=   Evaluate	random.randint(1, ${LINKS_IN_PAGE})	modules=random
    #\   Log     (${LINK_XPATH})[${RANDOM_NUMBER}]
    \   Set Focus To Element    xpath=(${LINK_XPATH})[${RANDOM_NUMBER}]
    \   ${FOCUS}=   Run Keyword And Return Status   Element Should Be Focused   xpath=(${LINK_XPATH})[${RANDOM_NUMBER}]
    \   Run Keyword If    "${FOCUS}" != "False"     Exit For Loop
    Go To    xpath=(${LINK_XPATH})[${RANDOM_NUMBER}]

Go To
    [Arguments]    ${LINK}
    #Log     Clickin on ${LINK}
    ${CURRENT_URL}=     Get Location
    Set Focus To Element    ${LINK}
    Click Element   ${LINK}
    Wait Until Element is Visible    xpath=${WIKI_LOGO_XPATH}

Expand Collapsed Sections
    ${COUNT}=   Get Element Count    xpath=${SHOW_XPATH}
    ${COUNT}=   Evaluate    ${COUNT} + 1
    FOR     ${INDEX}    IN RANGE     1    ${COUNT}
    \   Set Focus To Element    xpath=(${SHOW_XPATH})[1]
    \   Click Element   xpath=(${SHOW_XPATH})[1]