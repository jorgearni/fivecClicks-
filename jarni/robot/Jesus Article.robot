*** Variables ***
${JESUS PAGE UNIQUE IDENTIFIER}	//h1[contains(text(),"Jesus")]
${JESUS PAGE URL}	https://en.wikipedia.org/wiki/Jesus
*** Keywords ***
Am I With Jesus 
	${is this glory}=	Get Element Count	${JESUS PAGE UNIQUE IDENTIFIER}
	[RETURN]	${is this glory}
