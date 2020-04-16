*** Settings ***
Documentation  Goes to the 'Jesus' article in 5 clicks from any random article
...            Only uses links inside //*[@id="bodyContent"] ;)

Library  SeleniumLibrary
Resource  ../resources/Common.robot
Resource  ../resources/Wikipedia.robot
Resource  ../resources/links_to_Jesus.robot

Test Setup  Start Test
Test Teardown  Finish Test

*** Variables ***
${BROWSER}              firefox
${Categories_Link}      //a[@title][@href='/wiki/Help:Category']
${AlbertEinstein_Link}  //a[@title][@href='/wiki/Albert_Einstein']
${AshkenaziJews_Link}   //a[@title][@href='/wiki/Ashkenazi_Jews']
${Christians_Link}      //a[@title][@href='/wiki/Christians']
${Jesus_Link}           //a[@title][@href='/wiki/Jesus']
${article}              Jesus
${level}                2

*** Test Cases ***
Five Clicks To Jesus
    Click Link  Random article
    Click  ${Categories_Link}
    Click  ${AlbertEinstein_Link}
    Click  ${AshkenaziJews_Link}
    Click  ${Christians_Link}
    Click  ${Jesus_Link}
    Location Should Be  https://en.wikipedia.org/wiki/Jesus

Get Article Links
    #Test to get links inside an article
    Go To  https://en.wikipedia.org/wiki/Ypthima_congoana
    @{links}=  Get Article Links
    Print List  ${links}

Get Links
    Get Related Links  ${article}
    Clean File  ${EXECDIR}/resources/links_to_${article}.robot

Get More Links
    Get Related Links From Related Links  ${level_1}  ${article}  ${level}
    Clean File  ${EXECDIR}/resources/links_to_${article}_level_${level}.robot
