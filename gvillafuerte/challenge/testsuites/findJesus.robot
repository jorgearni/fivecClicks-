*** Settings ***
Resource  ../resources/pageUsage.robot
*** Variables ***
${howManyTimes}  13

*** Test Cases ***
Search For Jesus
    Open Browser  ${WIKIPEDIA_URL}  chrome
    Search Jesus  ${howManyTimes}
    Close All Browsers

