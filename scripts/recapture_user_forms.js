const puppeteer = require('puppeteer-core');
const path = require('path');

const BASE_URL = process.env.BASE_URL || 'http://localhost:8080';
const SCREENSHOT_DIR = path.resolve(__dirname, '../docs/screenshots');
const CHROME_PATH = process.env.CHROME_PATH || '/Applications/Google Chrome.app/Contents/MacOS/Google Chrome';

async function captureScreen(width, height, url, filename) {
    const browser = await puppeteer.launch({
        executablePath: CHROME_PATH,
        headless: 'new',
        args: ['--no-sandbox', '--disable-setuid-sandbox', '--disable-gpu', `--window-size=${width},${height}`]
    });
    try {
        const page = await browser.newPage();
        await page.setViewport({ width, height });
        await page.goto(`${BASE_URL}/login`, { waitUntil: 'domcontentloaded' });
        await page.$eval('input[name="username"]', el => el.value = 'admin');
        await page.$eval('input[name="password"]', el => el.value = 'password');
        await Promise.all([
            page.waitForNavigation({ waitUntil: 'domcontentloaded' }),
            page.click('button[type="submit"]')
        ]);
        if (page.url().includes('select-organization')) {
            await page.waitForSelector('table form button[type="submit"]', { timeout: 10000 });
            await Promise.all([
                page.waitForNavigation({ waitUntil: 'domcontentloaded' }),
                page.click('table form button[type="submit"]')
            ]);
        }
        await page.goto(url, { waitUntil: 'domcontentloaded' });
        await new Promise(r => setTimeout(r, 600));
        await page.screenshot({ path: path.join(SCREENSHOT_DIR, filename) });
        console.log(`[OK] Captured ${filename} (${width}x${height})`);
    } finally {
        await browser.close();
    }
}

(async () => {
    console.log('Capturing responsive user form screenshots...');
    await captureScreen(1440, 900, `${BASE_URL}/admin/users/create`, '09_admin_users_create.png');
    await captureScreen(390, 1200, `${BASE_URL}/admin/users/create`, '09_admin_users_create_mobile.png');
    await captureScreen(1440, 900, `${BASE_URL}/admin/users`, '08_admin_users_index.png');
    await captureScreen(390, 900, `${BASE_URL}/admin/users`, '08_admin_users_index_mobile.png');
    console.log('All responsive screenshots completed successfully.');
})();
