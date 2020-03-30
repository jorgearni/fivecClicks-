*** Settings ***
Documentation     A resource file with reusable keywords and variables.
Library           Selenium2Library
Library           Collections

*** Variables ***
${WIKIPEDIA_URL}  https://en.wikipedia.org
${RANDOM_ARTICLE_HREF}  /wiki/Special:Random
@{WORDS}  Christ_(disambiguation)  Jesus_of_Nazareth  Jesus_Christ  Christ_  Church  Galilean  Religion  Religious  Apostles  Christianity  God  Bible  Biblical  Messianic  Crucified  Testament  Catholic  Incarnation  Passion  Nazareth  Jewish  Messiah  Gospel  Baptize  Baptism  Rabbi  Pontious
...  Pilate  Spirit  Spiritualism  Holy_Spirit  Virgin  Miracle  Miracles  Crucifixion  Sacrament  Ascended  Heaven  Episcopal  Ritual  Christian  Easter  Islam  Prophet  Quran  Judaism  Jew  Hebrew  Moses  Jewish  Islamic  Yahweh  Sacred  Incarnation  Christmas  Prophecies  Holy  Blessed  Jehova  Priesthood
...  Saint  Saints   Salvation  Preached  Preacher  Preach  Vicker  Testament  Ministry  Resurrection  Epistle  Common_Era  Gregorian  Messiah  Priest  Holy  Spirit  Yehoshua  Koine  Transfiguration  Temple  Bethlehem  Mosque  HolySpirit  Divine  Supernatural  Judah  Roma
...  Satan  Ministry  Lamb_of_God  Babtism  AnnoDomini  Muslim  Prophecy  Exodus  Evangelist  Adventist  Parables  Sermon  Apocalyptic  Prodigal  Exorcism  Judas  Bethany  Blasphemy  Synagogue  Communion  Patriarcal  Ecclesial  Minister  Papal  Pentecost  Salvation  Beatitude  Rome  Vatican  Grail  Soul_
...  Dogma  Confessor  Pilgrimages  Rite  Grace  Liturgy  Absolution  Sin_  Mass  Penance  Clerical  Pope  Faith  Disciple  Sacrificies  Festivals  Trances  Hinduism  Budhism  Universe  Atheist  Monastery  Protestant  Lutheranism  Methodism  Babtist  Sect  Cult  Antichrist  Revelation  Armageddon
...  Puritanism  Quakerism  Lutheranism  Marian  Prediction  Mormon  Laity  Confirmation  Secular  Philosophical  Inquisition  Lucifer  Pagan  Cross  Worship  Cathedral
...  History  Origin  Historical  Republican_Party  Country


*** Keywords ***

Search Jesus
   [Arguments]  ${times}
   : FOR  ${INDEX}    IN RANGE    0    ${times}
   \    ${found}=   Search in Page  Jesus
   \    Run Keyword If  ${found}==True  Exit For Loop
   \    ${page}=  Get Location
   \    ${reference}=  Search Reference
   \    Run Keyword If  ${reference}==True  Go To  ${jreference}  ELSE  Click Random Article
   Run Keyword If  ${found}==True  Go To  ${jLink}
   Run Keyword If  ${found}==True  Log To Console  Jesus found in Link:${jLink}

Search Reference
    : FOR  ${word}  IN  @{WORDS}
       \  ${reference}=   Search Word in Links  ${word}
       \  Run Keyword If  ${reference}==True  Remove Values From List  ${WORDS}  ${word}
       \  Run Keyword If   ${reference}==True  Exit For Loop
       [Return]  ${reference}

Search in Page
    [Arguments]  ${word}
    ${links}=  Get WebElements  xpath://div[@id='mw-content-text']//a[contains(@href,'wiki')]
    : FOR  ${link}  IN  @{links}
    \    ${href}  Get Element Attribute  ${link}  href
    \    ${jFound}=  Evaluate   "${word}" in """${href}"""
    \    Run Keyword If  ${jFound}==True  Set Global Variable  ${jlink}  ${href}
    \    Run Keyword If  ${jFound}==True  Exit For Loop
    [Return]  ${jFound}

Search Word in Links
      [Arguments]  ${word}
      ${urls}=  Get WebElements  xpath://div[@id='mw-content-text']//a[contains(@href,'wiki')]
        : FOR  ${url}  IN  @{urls}
           \    ${href2}  Get Element Attribute  ${url}  href
           \    ${foundWord}=  Evaluate   """${word} """ in """${href2}"""
           \    Run Keyword If   ${foundWord}==True  Set Global Variable  ${jReference}  ${href2}
           \    Run Keyword If  ${foundWord}==True  Exit For Loop
    [Return]  ${foundWord}

Click Random Article
    Click Link  ${RANDOM_ARTICLE_HREF}
