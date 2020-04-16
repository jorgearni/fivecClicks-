*** Settings ***
Library  SeleniumLibrary
Library  OperatingSystem
Library  String

*** Keywords ***
Start Test
    Open Browser  https://en.wikipedia.org/  ${BROWSER}
    Maximize Browser Window

Finish Test
    Close Browser

Click
    [Arguments]  ${locator}
    Wait Until Element Is Enabled  ${locator}
    Click Element  ${locator}

Print List
    [Arguments]  ${list}
    FOR  ${item}  IN  @{list}
        Log To Console  ${item}
    END

Clean File
    [Arguments]  ${path}
    ${file_contents}=  GET FILE  ${path}
    ${file_contents}=  Replace String  ${file_contents}  ', '  \ \ \
    ${file_contents}=  Replace String  ${file_contents}  [  \
    ${file_contents}=  Replace String  ${file_contents}  '  \
    ${file_contents}=  Replace String  ${file_contents}  ]  \
    Create File  ${path}  ${file_contents}