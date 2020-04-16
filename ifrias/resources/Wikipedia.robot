*** Settings ***
Library  SeleniumLibrary
Library  Collections
Library  OperatingSystem
Library  String


*** Variables ***
${results_per_page}  5000
${results_per_page_annotated}  5,000

*** Keywords ***
Get Related Links
    [Arguments]  ${article}
    @{links}=  What Links Here  ${article}
    Create File  ${EXECDIR}/resources/links_to_${article}.robot  \*** Variables *** \n\@\{level_1\}= \ ${links}

Get Related Links From Related Links
    [Arguments]  ${articles}  ${root_article}  ${level}
    ${article_names}=  Get Article Names From Links  ${articles}
    @{links}=  CREATE LIST
    FOR  ${article}  IN  @{article_names}
        @{article_related_links}=  What Links Here  ${article}
        ${article_related_links_count}=  Get Length  ${article_related_links}
        RUN KEYWORD IF  $article_related_links_count > 1000  Append To List  ${links}  ${article_related_links}
    END
    Create File  ${EXECDIR}/resources/links_to_${root_article}_level_${level}.robot  \*** Variables *** \n\@\{level_${level}\}= \ ${links}

What Links Here
    [Arguments]  ${article}
    @{links_to_article}=  CREATE LIST
    Go To  https://en.wikipedia.org/w/index.php?title=Special:WhatLinksHere/${article}&namespace=0&limit=${results_per_page}
    Get Links To Here  ${links_to_article}
    Remove Values From List  ${links_to_article}  https://en.wikipedia.org/wiki/${article}
    [Return]  ${links_to_article}

Get Links To Here
    [Arguments]  ${links_to_here}
    Wait Until Element Is Visible  //*[@id="mw-whatlinkshere-list"]/li[1]/a
    @{WebElement_Links}=  Get Web Elements  //*[@id="mw-whatlinkshere-list"]/li/a[not(contains(@href,"#"))]
    Get Elements Attribute  ${WebElement_Links}  href  ${links_to_here}
    ${more_links_1}=  RUN KEYWORD AND RETURN STATUS  Element Text Should Be  //*[@id="mw-content-text"]/a[1]  next ${results_per_page_annotated}
    ${more_links_2}=  RUN KEYWORD AND RETURN STATUS  Element Text Should Be  //*[@id="mw-content-text"]/a[2]  next ${results_per_page_annotated}
    RUN KEYWORD IF  ${more_links_1}  Click Element  //*[@id="mw-content-text"]/a[1]
    RUN KEYWORD IF  ${more_links_2}  Click Element  //*[@id="mw-content-text"]/a[2]
    RUN KEYWORD IF  ${more_links_1} or ${more_links_2}  Get Links To Here  ${links_to_here}

Get Article Links
    @{article_links}=  CREATE LIST
    ${WebElement_links}=  Get Web Elements  //*[@id="mw-content-text"]//a[not(@class)][not(contains(@href,"#"))][not(contains(@href,"&action="))][not(contains(@href,":"))][not(contains(@href,"&action="))]
    Get Elements Attribute  ${WebElement_links}  href  ${article_links}
    [Return]  ${article_links}

Get Elements Attribute
    [Arguments]  ${WebElement_List}  ${attribute}  ${attributes_List}
    FOR  ${element}  IN  @{WebElement_List}
        ${attribute_text}=  Get Element Attribute  ${element}  ${attribute}
        Append To List  ${attributes_List}  ${attribute_text}
    END

Get Article Names From Links
    [Arguments]  ${links}
    @{split_urls}=  CREATE LIST
    FOR  ${url}  IN  @{links}
        RUN KEYWORD IF  '&redirect=' in $url  CONTINUE FOR LOOP
        @{split_url}=  Split String From Right  ${url}  separator=/  max_split=1
        Append To List  ${split_urls}  ${split_url}[1]
    END
    [Return]  ${split_urls}
