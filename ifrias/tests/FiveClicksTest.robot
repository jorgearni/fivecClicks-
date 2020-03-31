*** Settings ***
Documentation  Goes to the 'Jesus' article in 5 clicks from any random article
...            Only uses links inside //*[@id="bodyContent"] ;)

Library  SeleniumLibrary

Resource  ../resources/Common.robot

Test Setup  Start Test
Test Teardown  Finish Test

*** Variables ***
${BROWSER}  firefox
${Categories_Link}  //a[@title][@href='/wiki/Help:Category']
${AlbertEinstein_Link}  //a[@title][@href='/wiki/Albert_Einstein']
${AshkenaziJews_Link}  //a[@title][@href='/wiki/Ashkenazi_Jews']
${Christians_Link}  //a[@title][@href='/wiki/Christians']
${Jesus_Link}  //a[@title][@href='/wiki/Jesus']

*** Test Cases ***
Five Clicks To Jesus
    Wait Until Element Is Enabled  ${Categories_Link}
    Click Link  ${Categories_Link}
    Wait Until Element Is Enabled  ${AlbertEinstein_Link}
    Click Link  ${AlbertEinstein_Link}
    Wait Until Element Is Enabled  ${AshkenaziJews_Link}
    Click Link  ${AshkenaziJews_Link}
    Wait Until Element Is Enabled  ${Christians_Link}
    Click Link  ${Christians_Link}
    Wait Until Element Is Enabled  ${Jesus_Link}
    Click Link  ${Jesus_Link}
    Location Should Be  https://en.wikipedia.org/wiki/Jesus