const pptr = require('puppeteer');
require('dotenv').config();

async function updateIP() {
  const browser = await pptr.launch({args: ['--no-sandbox']});
  const page = await browser.newPage();
  await page.goto('https://www.noip.com/login');

  await page.click('input[name=username]')
  await page.keyboard.type(process.env.MAIL, {delay: 150})

  //await page.goto('https://www.noip.com/members/dns/host.php?host_id=77409448');

  await page.screenshot({path: 'ss.png'});
};

updateIP();
