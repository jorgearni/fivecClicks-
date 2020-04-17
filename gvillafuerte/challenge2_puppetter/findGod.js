const puppeteer = require('puppeteer');
var words = ["Jesus","Christ_","Nazareth","Church","Galilean","Religion","Religious","Apostles","Christianity","God","Bible","Biblical","Messianic","Crucified","Testament","Catholic","Holy","Incarnation","Nazareth","Jewish","Messiah","Gospel","Baptize","Baptism","Rabbi","Virgin","Miracle","Crucifixion","Sacrament","Ascended","Crusade","Heaven","Episcopal","Ritual","Easter","Islam","Prophet","Quran","Judaism","Jew","Hebrew","Moses","Islamic","Yahweh","Sacred","Christmas","Prophecies","Blessed","Jehova","Priesthood","Saint","Saints","Salvation","Preached","Preacher","Preach","Vicker","Ministry","Resurrection","Epistle","Common_Era","Gregorian","Priest","Yehoshua","Koine","Transfiguration","Temple","Bethlehem","Mosque","Spirit","Divine","Supernatural","Judah","Roma","Satan","Anno_Domini","Muslim","Bishop","Prophecy","Jerusalem","Exodus","Evangelist","Adventist","Parables","Sermon","Apocalyptic","Prodigal","Exorcism","Judas","Bethany","Blasphemy","Synagogue","Communion","Patriarcal","Ecclesial","Minister","Papal","Pentecost","Beatitude","Rome","Vatican","Grail","Soul_","Dogma","Confessor","Pilgrimages","Rite","Grace","Liturgy","Absolution","Sin_","Mass","Penance","Clerical","Pope","Faith","Disciple","Sacrificies","Festivals","Trance","Hinduism","Budhism","Universe","Atheist","Monastery","Protestant","Lutheranism","Methodism","Babtist","Sect","Cult","Antichrist","Revelation","Armageddon","Puritanism","Quakerism","Marian","Prediction","Mormon","Laity","Confirmation","Secular","Philosophical","Inquisition","Lucifer","Pagan","Cross","Worship","Cathedral","History","Origin","Republican","Country"];
var xpathForLinks = "#mw-content-text :any-link[href*=wiki]";

(async () => {
  const browser = await puppeteer.launch();
  const page = await browser.newPage();
  
  //await page.goto('https://en.wikipedia.org/wiki/Protestant_Bible');
  await page.goto('https://en.wikipedia.org');
  console.log("navigating to next random page");
  await page.click("a[href$='/wiki/Special:Random']");    

  var i = 0
  let foundWord = -1  
  let found = false
       while (i < 20 && found == false) {
             await page.waitForSelector(xpathForLinks);
             let checkUrl = await page.evaluate((xpathForLinks) => location.href);
                  if (checkUrl.includes("Jesus")){
                  found = true
                  } else {
                         console.log('Current page:'+ checkUrl);
                         const allURLS = await page.evaluate(() => {
                         const links = Array.from(document.querySelectorAll('#mw-content-text :any-link[href*=wiki]'))
                         return links.map(link => link.href) })
                                 for (let p = 0; p < words.length; p++) {
                                 let word = words[p];
                                 foundWord = (allURLS.findIndex(function(item){return item.indexOf(word)!==-1 ;}));
                                    if (foundWord!=-1) {
                                     console.log("found"+word+"in"+allURLS[foundWord]); 
                                      words.splice(p,1);
                                     await page.goto(allURLS[foundWord]);
                                  break;
                                     } 
                                  }

                                     if (foundWord==-1){
                                     await page.waitForSelector("a[href$='/wiki/Special:Random']");
                                     await page.click("a[href$='/wiki/Special:Random']");  
                                     }
                  }
         
      i++}
      if (found == true){
        console.log("Jesus found");
      } else
      { console.log("JesusNOT found"); }   
  await browser.close();


})();


