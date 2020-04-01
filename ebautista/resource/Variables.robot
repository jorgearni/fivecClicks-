*** Settings ***

*** Variables ***
################ XPATHS
${JESUS_WIKI}       //a[contains(@href, 'wiki/Jesus')]
${URL}              https://en.wikipedia.org/wiki/Special:Random
${LINK_XPATH}       //div[@id='bodyContent']//a[ starts-with(@href,'/wiki') and not(contains(@href, 'action=edit')) and not(contains(@class, 'image')) and not(contains(@class, 'redirect')) and not(contains(@href, '#')) and not(ancestor::*[contains(@class, 'hidden')]) ]
${WIKI_LOGO_XPATH}  //a[@class='mw-wiki-logo']
${SHOW_XPATH}       //a[text()='show']

################ VARIABLES
${BROWSER}          Chrome
${NUMBER_OF_LOOPS}  30
${NUMBER_OF_LOOPS_RANDOM_CLICK}  5
${JESUS_URL}        https://en.wikipedia.org/wiki/Jesus
@{CATHOLIC_PAGES}   jesus  virgin  christ  catholic  counting the cost  resurrection  incarnation  temptation  john henry newman  messiah  hell  crucifixion  last supper  parables  sermon on the mount  nazarene  theotokos  ihs