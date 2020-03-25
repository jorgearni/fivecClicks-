*** Settings ***
Library             SeleniumLibrary
Test Teardown       Close Browser

*** Variables ***
${browser}                Chrome
${homepage}               https://en.wikipedia.org
${random_article}         css:a[href="/wiki/Special:Random"]
${search_word}            Jesus
${target_link}            css:a[href="/wiki/${search_word}"]
${similar_target_link}    css:a[href*="wiki/${search_word}"]
${found_target}           ${False}

*** Keywords ***
Get Element
  [Arguments]  ${locator}
  Wait Until Element Is Visible  ${locator}  timeout=2s
  [Return]  Get WebElement  ${locator}  

Click Random Article
  Click Element  ${random_article}

Click Similar Article
  Click Element  ${${similar_target_link}}


Set Found To True
  ${found_taget}=  ${True}

Search Target In Page And Click Random
  ${target_link}=  Search for target link
  ${similar_target_link}=  Search for similar target link 
  Run Keyword If  '${similar_target_link}' == 'True'  Click Similar Article
  Run Keyword If  '${target_link}' == 'False'  Click Random Article
  Run Keyword If  '${target_link}' == 'True'  Set Found To True

Search for target link
  ${target_found}=  Run Keyword And Return Status  Get Element  ${target_link}
  [Return]  ${target_found}

Search for similar target link
  ${similar_target_found}=  Run Keyword And Return Status  Get Element  ${similar_target_link}
  [Return]  ${similar_target_found}
 

*** Test Cases ***
Find Jesus
  Open Browser  ${homepage}  ${browser}
  FOR  ${index}  IN RANGE  50
    Search Target In Page And Click Random
    ${location}=  Get Location
    Log  ${location}
    Run Keyword If    '${found_target}' == 'True'    Exit For Loop
  END



