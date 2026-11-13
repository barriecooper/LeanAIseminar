// Optional maintainer integration check: requires Playwright and a Chromium binary.
// Start the documented server/task first, then run `node tests/browser.cjs`.
const {chromium} = require('playwright');
const assert = require('node:assert/strict');
const {join} = require('node:path');
(async () => {
  const browser = await chromium.launch({
    ...(process.env.CHROMIUM_PATH ? {executablePath: process.env.CHROMIUM_PATH} : {}),
    headless: true
  });
  try {
    const page = await browser.newPage({viewport: {width: 1360, height: 1050}});
    const errors = [];
    const requests = [];
    page.on('pageerror', e => errors.push(e.message));
    page.on('request', request => requests.push(request.url()));
    const start = Date.now();
    await page.goto('http://127.0.0.1:8000');
    await page.locator('#status').filter({hasText: 'Plots updated'}).waitFor();
    console.log(`Initial browser load + render: ${Date.now() - start} ms`);
    for (const r of ['2.5', '3.2', '3.5', '3.9']) {
      await page.getByRole('button', {name: r, exact: true}).click();
      await page.waitForFunction(r => document.querySelector('#status').textContent.endsWith(`r = ${r}.`), r);
      assert.equal(await page.locator('#r').inputValue(), r);
      assert.equal(await page.getByRole('button', {name: r, exact:true}).getAttribute('aria-pressed'), 'true');
    }
    await page.locator('#r-slider').focus();
    await page.keyboard.press('Home');
    await page.waitForFunction(() => document.querySelector('#status').textContent.endsWith('r = 0.'));
    assert.equal(await page.locator('#r').inputValue(), '0');
    await page.locator('#r').fill('3.5');
    await page.locator('#x0').fill('0.42857142857142855');
    await page.locator('#transient').fill('0');
    await page.locator('#count').fill('10');
    await page.waitForFunction(() => document.querySelector('#orbit-caption').textContent.includes('Showing x0 through x9'));
    assert.match(await page.locator('#orbit-caption').innerText(), /0.428571, 0.857143, 0.428571/);
    await page.locator('#r').fill('');
    await page.locator('#error').filter({hasText:'Choose r'}).waitFor();
    assert.match(await page.locator('#status').innerText(), /Plots unchanged/);
    await page.locator('#r').fill('4');
    await page.locator('#x0').fill('0');
    await page.waitForFunction(() => document.querySelector('#orbit-caption').textContent.includes('First values: 0.000000, 0.000000'));
    await page.locator('#count').fill('501');
    await page.locator('#error').filter({hasText:'between 2 and 500'}).waitFor();
    // Exercise the bounded worst-case diagram; report an observation, not a promise.
    await page.locator('#count').fill('500');
    await page.locator('#x0').fill('0.2');
    await page.locator('#transient').fill('5000');
    await page.waitForFunction(() => document.querySelector('#orbit-caption').textContent.includes('Showing x5000 through x5499'));
    console.log('Maximum settings:', await page.locator('#status').innerText());
    await page.locator('#r').fill('3.5');
    await page.locator('#count').fill('80');
    await page.locator('#transient').fill('500');
    await page.waitForFunction(() => document.querySelector('#orbit-caption').textContent.includes('Showing x500 through x579'));
    await page.mouse.move(5, 5);
    await page.locator("#transient").blur();
    await page.screenshot({path:join(__dirname, '../docs/workshop-explorer.png'), fullPage:true});
    await page.setViewportSize({width:390, height:844});
    assert.ok(await page.evaluate(() => document.documentElement.scrollWidth <= innerWidth));
    await page.context().setOffline(true);
    await page.getByRole('button', {name:'2.5', exact:true}).click();
    await page.waitForFunction(() => document.querySelector('#status').textContent.endsWith('r = 2.5.'));
    assert.match(await page.locator('#orbit-caption').innerText(), /0.600000/);
    assert.ok(requests.every(url => url.startsWith('http://127.0.0.1:8000/')));
    assert.deepEqual(errors, []);
    const noJs = await browser.newContext({javaScriptEnabled:false});
    const fallback = await noJs.newPage();
    await fallback.goto('http://127.0.0.1:8000');
    await fallback.locator('noscript a').click();
    await fallback.locator('svg').waitFor();
    console.log('Presets, keyboard slider, input validation, exact-cycle illustration, boundary seed, mobile layout, offline controls and no-JS fallback passed.');
    await noJs.close();
  } finally { await browser.close(); }
})().catch(e => {console.error(e);process.exitCode=1;});
