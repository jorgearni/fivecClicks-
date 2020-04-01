*** Settings ***
Library     Selenium2Library
Resource            Variables.robot

*** Variables ***

*** Keywords ***
Open Initial Random Page
    Open browser    ${URL}   ${BROWSER}
    Set Window Size  1280  800
    #Maximize Browser Window

Close Browsers
    Close All Browsers
