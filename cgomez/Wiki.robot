*** Settings ***
Library             SeleniumLibrary

*** Variables ***
${WIKI_LINK}      https://en.wikipedia.org
${RANDOM_LINK}    ${WIKI_LINK}/wiki/Special:Random
${JESUS_LINK}     ${WIKI_LINK}/wiki/Jesus
${JESUS_LOCATOR}  //a[@title][@href='${JESUS_LINK}']
${BROWSER}        chrome
@{LIST}  jesus  christ  nazareth  messiah  crucifi  resurrection  testament  disciples  apostles  jerusalem  hebrew  holy  religious  gospel  bible  priest  church  temple  saint  apostle  thomas  simon  peter  matthew  judas  john  james  bartholomew  andrew  god  roman

*** Test Cases ***
Look For Jesus
    Open Browser  ${WIKI_LINK}  ${BROWSER}
    Set Window Size  1280  800
    Compare URL
    Look For Jesus Link
    Look For Links Related
    Keep Looking

*** Keywords ***
Compare URL
    # Capture Page Screenshot
    ${current} =  Get Location
    Log To Console    ${current}
    ${status} =  Run Keyword And Return Status  Should Be Equal  ${JESUS_LINK}  ${current}  ignore_case=True
    Run Keyword If  ${status}  Pass Execution  Jesus Has Been Found

Look For Jesus Link
    ${count} =  Get Element Count  ${JESUS_LOCATOR}
    Run Keyword If  ${count} > 0  Check Link  ${JESUS_LOCATOR}

Check Link
    [Arguments]  ${locator}
    ${link} =  Get Element Attribute  ${locator}  href
    Go To  ${link}
    Compare URL
    Look For Jesus Link

Look For Links Related
    :FOR  ${i}  IN  @{LIST}
    # \  Log To Console  ${i}
    \  ${count} =  Get Element Count  //a[@title][contains(@href,'wiki')][contains(translate(.,'ABCDEFGHIJKLMNOPQRSTUVWXYZ','abcdefghijklmnopqrstuvwxyz'),'${i}')]
    # \  Log To Console  ${count}
    \  Run Keyword If  ${count} > 0  Check Link  //a[@title][contains(@href,'wiki')][contains(translate(.,'ABCDEFGHIJKLMNOPQRSTUVWXYZ','abcdefghijklmnopqrstuvwxyz'),'${i}')]
    \  Run Keyword If  ${count} > 0  Look For Links Related
    # \  Exit For Loop If  ${count} > 0

Keep Looking
    Go To  ${RANDOM_LINK}
    Compare URL
    Look For Jesus Link
    Look For Links Related
    Keep Looking
