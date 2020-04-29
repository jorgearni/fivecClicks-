const puppeteer = require('puppeteer');

const DEBUG = false;
const MAX_RETRIES = 30;

const PREFIX_URL = 'https://en.wikipedia.org';
const JESUS_HREF = '/wiki/Jesus';
const JESUS = 'Jesus';
const TARGET_URL = PREFIX_URL + JESUS_HREF;
const START_URL =  PREFIX_URL + '/wiki/Special:Random';

const BODY_CONTENT_LOCATOR = 'div#bodyContent';
const LINKS_LOCATOR = BODY_CONTENT_LOCATOR + ' a[href^="/wiki"]:not([href*=":"])[title]';

const WORDS = ['Jesus', 'Christ', 'God',  'Religi', 'Catholi' , 'Bible',  'Teacher',
               'Islam',  'Buda',  'Koran',  'Baptism', 'Jerusalem', 'Israel',
               'Resurrection',  'Alpha',  'Omega',  'Church',  'Crucifixion',  'Nazarene',
               'Maria', 'Mary', 'Virgin',   'Heaven',   'Trinity',   'Saint',   'Spirit',   'Holly',  'Prophet',
               'Hell',  'Devil',  'Satan', 'ISBN'];


var VISITED_LINKS = [];


function isSamePage(thisUrl, targetUrl){
    if (DEBUG){
        console.log(thisUrl);
        console.log(targetUrl);
    }
    return (thisUrl == targetUrl);
}

function getRndInteger(min, max) {
    return Math.floor(Math.random() * (max - min + 1) ) + min;
}

function inVisitedLinks(href){
    if (href == JESUS_HREF) return false;
    for (const link of VISITED_LINKS){
        if (href.includes(JESUS)){
            if (link == PREFIX_URL + href) return true;
        }
        else if (link.includes(href)) return true;
    }
    return false;
}

const randomClick = async(page) => {
    const links = await page.$$(LINKS_LOCATOR);
    if (DEBUG) console.log('RandomClick: links.length = ' + links.length);
    if (links.length == 0) {
        await goBackAndRandomClick(page);
    } else {
        var clicked = false;
        do {
            var index = getRndInteger(0, links.length - 1);
            var hrefLink = await page.evaluate(span => span.getAttribute('href'), links[index]);
            if (DEBUG) console.log('RandomClick: index = ' + index);
            if (DEBUG) console.log('RandomClick: href = '+ hrefLink);
            if (inVisitedLinks(hrefLink)){
                if (DEBUG) console.log('RandomClick: href in visited links, ignoring click...');
                continue;
            }
            try {
                const locatorClick = BODY_CONTENT_LOCATOR +' a[href="'+ hrefLink +'"]';
                await page.click(locatorClick);
                clicked = true;
            } catch (err) {
                clicked = false;
                if (DEBUG){
                    console.log('RandomClick: Cannot click element');
                    //console.log (err);
                }
            }
        } while (!clicked);
     }
}

const goBackAndRandomClick = async (page) => {
    if (DEBUG) console.log ("goBackAndRandomClick");
    const lastPage = VISITED_LINKS[VISITED_LINKS.length - 1];
    await page.goto(lastPage);
    await randomClick(page);
}

const main = async () => {
  var retries = 1;
  var WORDS_USED = [];

  const browser = await puppeteer.launch();
  const page = await browser.newPage();
  await page.goto(START_URL);
  VISITED_LINKS.push(page.url());
  if (DEBUG) console.log(page.url());
  var isJesusPage = isSamePage(page.url(), TARGET_URL);

  while (!isJesusPage && retries <= MAX_RETRIES) {
    var found = false;
    for (const word of WORDS) {
        try {
            const locator = LINKS_LOCATOR + '[href*="' + word +'"]';
            var hrefLink = await page.$eval(locator, a => a.getAttribute('href'));
            if (inVisitedLinks(hrefLink)){
                if (DEBUG) console.log('word repeated = '+word+', ignoring click...');
                WORDS_USED.push(word);
                continue;
            }
            await page.click(locator);
            found = true;
            VISITED_LINKS.push(page.url());
            WORDS_USED.push(word);
            if (DEBUG) console.log(word);
            break;
        } catch(err) {
            if (DEBUG) console.log('No link found for locator including: '+ word);
        }
    }

    if (!found) {
        await randomClick(page);
        VISITED_LINKS.push(page.url());
    }

    if (DEBUG) console.log(page.url());

    isJesusPage = isSamePage(page.url(), TARGET_URL);
    retries++;
  }

  if (DEBUG) console.log(page.url());
  if (DEBUG) console.log(WORDS_USED);
  console.log(VISITED_LINKS);
  console.log(retries-1);

  await browser.close();
  return retries-1
}

main()