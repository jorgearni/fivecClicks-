*** Settings ***
Library  SeleniumLibrary

*** Keywords ***
Start Test
    Open Browser  https://en.wikipedia.org/  ${BROWSER}
    Maximize Browser Window
    Click Link  Random article

Finish Test
    Close Browser