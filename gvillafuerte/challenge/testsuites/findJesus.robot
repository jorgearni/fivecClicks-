*** Settings ***
Resource  ../resources/pageUsage.robot
*** Variables ***
${howManyTimes}  7
${whichGod}  Jesus
*** Test Cases ***
Search For God
    Open Browser  ${WIKIPEDIA_URL}  chrome
    Click Random Article
    Search a God  ${howManyTimes}
    Close All Browsers

