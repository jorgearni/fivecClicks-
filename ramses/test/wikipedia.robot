*** Settings ***
Library             SeleniumLibrary
Library             String
Test Teardown       Close Browser

*** Variables ***
${browser}                Chrome
${timeout}                1s
${homepage}               https://en.wikipedia.org
${random_article}         css:a[href="/wiki/Special:Random"]
${search_word}            Jesus
@{synonyms}               Jesus  Society  Religion  Christ  Mesiah  Catholic  Vatican  Pope  Bible
${target_link}            css:a[href="/wiki/${search_word}"]
${similar_target_link}    css:a[href*="/wiki/${search_word}"]
${template}               css:a[href*="{string}"]

*** Keywords ***
Log Location
  ${location}=  Get Location
  Log To Console  ${location}

Click Visible Element
  [Arguments]  ${locator}
  Wait Until Element Is Visible  ${locator}  timeout=${timeout}
  Click Element  ${locator}

Get Element
  [Arguments]  ${locator}
  Wait Until Element Is Visible  ${locator}  timeout=${timeout}
  [Return]  Get WebElement  ${locator}  

Get Element From Synonym
  [Arguments]  ${synonym}
  ${target_link}=  Format Locator  ${template}  ${synonym}
  ${element}=  Get WebElement  ${target_link}  
  [Return]  ${element}  

Click Element From Synonym  
  [Arguments]  ${synonym}
  ${target_link}=  Format Locator  ${template}  ${synonym}
  Log  ${target_link}
  Click Visible Element  ${target_link}

Click Target
  Click Visible Element  ${target_link}

Format locator
  [Arguments]  ${template}  ${string}
  ${locator}=  Format String  ${template}  string=${string}
  Log  ${locator}
  [Return]  ${locator}    

Click Random Article
  Click Visible Element  ${random_article}

Set Found To True
  ${found_taget}=  Set Test Variable  ${TRUE}

Search for target link
  ${target_found}=  Run Keyword And Return Status  Get Element  ${target_link}
  Run Keyword If  '${target_found}' == 'True'  Set Found To True
  Run Keyword If  '${target_found}' == 'True'  Click Target
  Run Keyword If  '${target_found}' == 'True'  Log Location
  [Return]  ${target_found}

Search for similar target link
  FOR  ${synonym}  IN  @{synonyms}
    Log Location
    ${target_link}=  Search for target link
    Exit For Loop If    '${target_link}' == 'True'
    ${similar_target_found}=  Run Keyword And Return Status  Get Element From Synonym  ${synonym}
    Run Keyword If    '${similar_target_found}' == 'True'    Click Element From Synonym  ${synonym}
    Exit For Loop If  '${target_link}' == 'True'
  END
  [Return]  ${target_link}

Search Target In Page And Click Random
  ${similar_target_link}=  Search for similar target link 
  Run Keyword If  ${similar_target_link} == 'False'  Click Random Article
  [Return]  ${similar_target_link}

*** Test Cases ***
Find Jesus
  Open Browser  ${homepage}  ${browser}
  FOR  ${index}  IN RANGE  6
    Log Location
    ${found}=  Search Target In Page And Click Random
    Exit For Loop If  '${found}' == 'True'
  END



