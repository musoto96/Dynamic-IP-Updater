const pptr = require('puppeteer');
require('dotenv').config();

async function updateIP(newIP) {
  const browser = await pptr.launch({args: ['--no-sandbox']});
  const page = await browser.newPage();

  await page.setViewport({
    width: 1366, 
    height: 768,
    deviceScaleFactor: 0.5,
  });

  await page.goto('https://www.noip.com/login');

  await page.click('input[name="username"]')

  const credentials = { "mail": process.env.MAIL, "passwd": process.env.PASSWD };

  await page.evaluate((credentials) => {
    document.querySelector('input[name=username]').value = credentials.mail;
    document.querySelector('input[name=password]').value = credentials.passwd;
  }, credentials);

  await page.evaluate(() => {
    document.querySelector('button[name=Login]').click();
  });

  // wait for this element
  //document.querySelector(".stat-panel")
  //page.waitForSelector(".stat-panel", {visible=true})

  await page.waitForTimeout(10000)

  // SETUP START
  // Update this link with your DNS Records "Update host" panel link
  //  the screen where you enter an IP to update your hostname.
  await page.goto('https://www.noip.com/members/dns/host.php?host_id=77409448');
  // SETUP END
  
  await page.waitForTimeout(10000)

  await page.evaluate((newIP) => {
    document.querySelector("#ip").value = newIP;
  }, newIP);

  await page.evaluate(() => {
    document.querySelector("input[value='Update Hostname']").click();
  });

  //await page.screenshot({path: 'ss.png'});
  await page.waitForTimeout(10000)
  await browser.close();
};

updateIP(process.argv[2]);
