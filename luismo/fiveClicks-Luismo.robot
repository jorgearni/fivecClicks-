*** Settings ***
Library             SeleniumLibrary

*** Variables ***
${WIKIPEDIA}           https://en.wikipedia.org
${RANDOM_ARTICLE}      ${WIKIPEDIA}/wiki/Special:Random
${BROWSER}             chrome
${WIKI_JESUS}          ${WIKIPEDIA}/wiki/Jesus
@{JESUS_RELATED_LIST}  god  jesus  christ  holy  catholic  christian  trinity  messiah  resurrection  cross  apostle  joy  eternal  mercy  kingdom  judgement  jew  muslim  jerusalem  baptist  savior  nazareth  judaism  satan  miracle  bible  prophet  judea  crucifixion  gabriel  gnosticism  monotheism  sin  temple  religion  reincarnation  dove  salvation  devil  pagan  prayer  islam  quran  calvary  israel  protestant  angel  taoist  conception  governor  king  canonize  tax  hitler  lamb  omnipresence  saint  corinthians  christmas

*** Test Cases ***
Search for Jesus
    Open Browser  ${Wikipedia}  ${BROWSER}
    Maximize Browser Window
    Match URL
    Obtain Wiki Links
    Look Jesus Link Into Wiki Links
    Keep Searching

*** Keywords ***
Obtain Wiki Links
    # Obtain the count of all the links in the page
    ${AllLinksCount}=  Get Element Count  xpath://a[@title][@href='${Text}']
    Log To Console  ${AllLinksCount}
    # Create a list with all the links in the page
    @{LinkItems}  Create List
    : For  ${i}  In Range  1  ${AllLinksCount}+1
    \  ${linkText}= Get Text  xpath://a[@title][@href='${Text}']

Look Jesus Link Into Wiki Links
    ${count} =  Get Element Count  ${WIKI_JESUS}
    Run Keyword If  ${count} > 0  Check Link  ${WIKI_JESUS}

Keep Searching
    Get First Link By Priority
    Go To  ${RANDOM_LINK}
    Match URL
    Obtain Wiki Links
    Look Jesus Link Into Wiki Links
    Keep Searching


Match URL
    ${ACTUAL_PAGE} =  Get Location
    Log To Console    ${ACTUAL_PAGE}
    ${passed} =  Run Keyword And Return Status  Should Be Equal  ${WIKI_JESUS}  ${ACTUAL_PAGE}  ignore_case=True
    Run Keyword If  ${passed}  Pass Execution  You Found Jesus


Get First Link By Priority
    [Arguments]  @{links}
    FOR  ${related}  IN  @{JESUS_RELATED_LIST}
        FOR  ${link}  IN  @{links}
            Return From Keyword If  '${related}' in '${link}'  ${link}
        END
    END
    ${RANDOM_LINK} =  Evaluate  random.choice(@links)  modules=random
    [Return]  ${RANDOM_LINK}
    Log To Console  ${RANDOM_LINK}
