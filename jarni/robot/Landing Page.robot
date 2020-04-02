*** Variables *** 
${LANDING URL}	https://en.wikipedia.org/wiki/Main_Page
${RANDOM ARTICLE LINK}	xpath: //*[contains(text(), "Random article")]

*** Keywords ***
Am I in The Landing Page 
	Element Should Be Visible	${RANDOM ARTICLE LINK}


Open A Random Article 
	Click Element	${RANDOM ARTICLE LINK} 
