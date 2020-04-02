*** Settings ***
Resource	Jesus Article.robot
Resource	Landing Page.robot
Resource	Random Article.robot
Library	SeleniumLibrary
Library    Collections
Suite Teardown   Close Browser

*** Keywords ***
Jesus Are You There 
	${valid links}=	Get All Links
	${value}=	Evaluate	random.choice(${valid links})	random
	log to console	\nvalue: ${value}
	
	
Look For Jesus
	[Arguments]	${article list}	${jump counter}
	Run Keyword Unless	${jump counter} == 5	Jesus Are You There
	Look For Jesus	@{article list}	${jump counter}
	
*** Test Cases ***
Find Jesus
	Open Browser	${LANDING URL}	chrome
	${JUMP COUNTER}=	Set Variable	0
	@{ARTICLE LIST}=	Create List
	Am I In The Landing Page
	Open A Random Article
	${CURRENT LOCATION}=	Get Location
	Append To List	${ARTICLE LIST}	${CURRENT LOCATION}
	Log List	${ARTICLE LIST}
	${IS THIS JESUS PAGE}=	Am I With Jesus
	Run Keyword Unless	${IS THIS JESUS PAGE}	Look For Jesus	${ARTICLE LIST}	${JUMP COUNTER}
