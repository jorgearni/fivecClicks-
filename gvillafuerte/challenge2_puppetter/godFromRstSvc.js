const puppeteer = require('puppeteer');
var words = '';
var xpathForLinks = "#mw-content-text :any-link[href*=wiki]";
const http = require('http');
const jp = require('jsonpath');


(async () => {
    const browser = await puppeteer.launch();
    const page = await browser.newPage();
    await makeSynchronousRequest();
    await page.goto('https://en.wikipedia.org');
    await page.click("a[href$='/wiki/Special:Random']");

    var i = 0
    let foundWord = -1
    let found = false
    while (i < 20 && found == false) {
        await page.waitForSelector(xpathForLinks);
        let checkUrl = await page.evaluate((xpathForLinks) => location.href);
        if (checkUrl.includes("Jesus")) {
            found = true
        } else {
            console.log('Current page:' + checkUrl);
            const allURLS = await page.evaluate(() => {
                const links = Array.from(document.querySelectorAll('#mw-content-text :any-link[href*=wiki]'))
                return links.map(link => link.href)
            })
            for (let p = 0; p < words.length; p++) {
                let word = words[p];
                foundWord = (allURLS.findIndex(function(item) {
                    return item.indexOf(word) !== -1;
                }));
                if (foundWord != -1) {
                    console.log("found" + word + "in" + allURLS[foundWord]);
                    words.splice(p, 1);
                    await page.goto(allURLS[foundWord]);
                    break;
                }
            }
            if (foundWord == -1) {
                await page.waitForSelector("a[href$='/wiki/Special:Random']");
                await page.click("a[href$='/wiki/Special:Random']");
                console.log("navigating to next random page");
            }
        }
        i++
    }
    if (found == true) {
        console.log("Jesus found");
    } else {
        console.log("Jesus not found");
    }
    await browser.close();
})
();



function getWordsDB() {
    return new Promise((resolve, reject) => {
        http.get('http://localhost:3000/words/', (resp) => {
            let data = '';
            resp.on('data', (chunk) => {
                data += chunk;
            });
            resp.on('end', () => {
                var term = jp.query((JSON.parse(data)), '$..term');
                resolve(term);
            });
            resp.on('error', (error) => {
                reject(error);
            });
        });
    });
}

// async function to make http request
async function makeSynchronousRequest(request) {
    try {
        let http_promise = getWordsDB();
        words = await http_promise;
        console.log(words);
    } catch (error) {
        console.log(error);
    }
}

