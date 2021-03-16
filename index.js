const pptr = require('puppeteer');

async function updateIP() {
  const browser = await pptr.launch();
  const page = await browser.newPage();
  await page.goto('https://www.noip.com/login?ref_url=%2Fmembers%2Fdns%2Fmanage_domains');
};

updateIP();
