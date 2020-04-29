*** Settings ***
Documentation     A resource file with reusable keywords and variables.
Library           Selenium2Library
Library           Collections

*** Variables ***
${WIKIPEDIA_URL}  https://en.wikipedia.org
${RANDOM_ARTICLE_HREF}  /wiki/Special:Random
@{WORDS}  Jesus  Christ_  Nazareth  Church  Galilean  Religion  Religious  Apostles  Christianity  God  Bible  Biblical  Messianic  Crucified  Testament  Catholic  Holy  Incarnation  Nazareth  Jewish
...  Messiah  Gospel  Baptize  Baptism  Rabbi  Virgin  Miracle  Crucifixion  Sacrament  Ascended  Crusade  Heaven  Episcopal  Ritual  Christian  Easter  Islam  Prophet  Quran  Judaism  Jew  Hebrew  Moses  Islamic  Yahweh
...  Sacred  Christmas  Prophecies  Blessed  Jehova  Priesthood  Saint  Saints  Salvation  Preached  Preacher  Preach  Vicker  Ministry  Resurrection  Epistle  Common_Era  Gregorian  Priest  Yehoshua  Koine
...  Transfiguration  Temple  Bethlehem  Mosque  Spirit  Divine  Supernatural  Judah  Roma  Satan  Anno_Domini  Muslim  Bishop  Prophecy  Jerusalem  Exodus  Evangelist  Adventist  Parables  Sermon  Apocalyptic  Prodigal  Exorcism
...  Judas  Bethany  Blasphemy  Synagogue  Communion  Patriarcal  Ecclesial  Minister  Papal  Pentecost  Beatitude  Rome  Vatican  Grail  Soul_  Dogma  Confessor  Pilgrimages  Rite  Grace  Liturgy  Absolution
...  Sin_  Mass  Penance  Clerical  Pope  Faith  Disciple  Sacrificies  Festivals  Trance  Hinduism  Budhism  Universe  Atheist  Monastery  Protestant  Lutheranism  Methodism  Babtist  Sect  Cult  Antichrist  Revelation
...  Armageddon  Puritanism  Quakerism  Marian  Prediction  Mormon  Laity  Confirmation  Secular  Philosophical  Inquisition  Lucifer  Pagan  Cross  Worship  Cathedral  History  Origin  Republican_Party  Country
${XPATHFORLINKS}  //div[@id='mw-content-text']//a[contains(@href,'wiki')]
${jreference}
${jlink}

*** Keywords ***

Search a God
   [Arguments]  ${times}
   : FOR  ${INDEX}    IN RANGE    0    ${times}
   \    ${found}=   Search Word in Page Links  ${whichGod}  jlink
   \    Run Keyword If  ${found}==True  Exit For Loop
   \    ${page}=  Get Location
   \    ${reference}=  Search Reference
   \    Run Keyword If  ${reference}==True  Go To  ${jreference}  ELSE  Click Random Article
   Run Keyword If  ${found}==True  Go To  ${jLink}
   Run Keyword If  ${found}==True  Log To Console  ${whichGod} found in Link:${jlink}  ELSE  Log To Console  ${whichGod} Not found in: ${page}

Search Word in Page Links
      [Arguments]  ${word}  ${reference}
      ${urls}=  Get WebElements  xpath:${XPATHFORLINKS}
        : FOR  ${url}  IN  @{urls}
           \    ${href2}  Get Element Attribute  ${url}  href
           \    Log To Console  searching..${word} in..${href2}
           \    ${foundWord}=  Evaluate   "${word}" in """${href2}"""
           \    Run Keyword If  ${foundWord}==True  Set Global Variable  ${${reference}}  ${href2}
           \    Run Keyword If  ${foundWord}==True  Exit For Loop
    [Return]  ${foundWord}

Search Reference
    : FOR  ${word}  IN  @{WORDS}
       \  ${reference}=   Search Word in Page Links  ${word}  jreference
       \  Run Keyword If  ${reference}==True  Remove Values From List  ${WORDS}  ${word}
       \  Log To Console  Find ${word} in ${jreference}
       \  Run Keyword If   ${reference}==True  Exit For Loop
       [Return]  ${reference}



Click Random Article
    Click Link  ${RANDOM_ARTICLE_HREF}


