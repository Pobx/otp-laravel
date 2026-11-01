/**
 * OTP 2025 - Master E2E Screenshot Capture Runner
 * 
 * Runs end-to-end browser tests across all 6 core system domains
 * and saves full visual evidence to `docs/screenshots/`.
 */

const puppeteer = require('puppeteer-core');
const fs = require('fs');
const path = require('path');

const BASE_URL = process.env.BASE_URL || 'http://localhost:8080';
const SCREENSHOT_DIR = path.resolve(__dirname, '../docs/screenshots');
const CHROME_PATH = process.env.CHROME_PATH || '/Applications/Google Chrome.app/Contents/MacOS/Google Chrome';

if (!fs.existsSync(SCREENSHOT_DIR)) {
    fs.mkdirSync(SCREENSHOT_DIR, { recursive: true });
}

async function withPage(fn) {
    const browser = await puppeteer.launch({
        executablePath: CHROME_PATH,
        headless: 'new',
        args: [
            '--no-sandbox',
            '--disable-setuid-sandbox',
            '--disable-gpu',
            '--disable-dev-shm-usage',
            '--window-size=1440,900'
        ]
    });
    try {
        const page = await browser.newPage();
        await page.setViewport({ width: 1440, height: 900 });
        await fn(page);
    } finally {
        await browser.close();
    }
}

async function loginUser(page, username, password = 'password') {
    await page.goto(`${BASE_URL}/login`, { waitUntil: 'domcontentloaded' });
    await page.$eval('input[name="username"]', (el, u) => el.value = u, username);
    await page.$eval('input[name="password"]', (el, p) => el.value = p, password);
    await Promise.all([
        page.waitForNavigation({ waitUntil: 'domcontentloaded' }),
        page.click('button[type="submit"]')
    ]);
    await new Promise(r => setTimeout(r, 400));
}

async function loginAndSelectOrg(page, username = 'admin', password = 'password') {
    await loginUser(page, username, password);
    if (page.url().includes('select-organization')) {
        await page.waitForSelector('table form button[type="submit"]', { timeout: 10000 });
        await Promise.all([
            page.waitForNavigation({ waitUntil: 'domcontentloaded' }),
            page.click('table form button[type="submit"]')
        ]);
        await new Promise(r => setTimeout(r, 400));
    }
}

async function captureScreen(page, filename, url = null) {
    if (url && page.url() !== url) {
        const res = await page.goto(url, { waitUntil: 'domcontentloaded' });
        if (res && res.status() >= 400) {
            throw new Error(`HTTP Error ${res.status()} when visiting ${url}`);
        }
    }
    await new Promise(r => setTimeout(r, 600));
    const filePath = path.join(SCREENSHOT_DIR, filename);
    await page.screenshot({ path: filePath, fullPage: false });
    console.log(`  [OK] Saved docs/screenshots/${filename}`);
}

async function runBatch(batchTitle, targets, defaultAuthMode = 'admin') {
    console.log(`\n===============================================================`);
    console.log(batchTitle);
    console.log(`===============================================================`);

    for (const item of targets) {
        const [filename, url, customUser] = item;
        await withPage(async page => {
            if (customUser === false || (!customUser && defaultAuthMode === 'none')) {
                // Public page, no login needed
            } else if (defaultAuthMode === 'admin' && (!customUser || customUser === 'admin')) {
                await loginAndSelectOrg(page, 'admin');
            } else {
                const user = customUser || defaultAuthMode;
                await loginUser(page, user);
            }
            console.log(`Capturing ${filename} -> ${url || page.url()}`);
            await captureScreen(page, filename, url);
        });
    }
}

async function main() {
    console.log('OTP 2025: Starting Full E2E Screenshot Capture Pipeline');

    // 1. Auth & Portals
    await runBatch('[1/6] Authentication & Role Portals', [
        ['01_auth_login.png', `${BASE_URL}/login`, false],
        ['02_super_admin_select_org.png', null, 'admin'],
        ['03_super_admin_accessmenu.png', `${BASE_URL}/accessmenu`, 'admin'],
        ['04_tabwater_staff_portal.png', `${BASE_URL}/staff_accessmenu`, 'water_staff'],
        ['05_recycle_staff_portal.png', `${BASE_URL}/accessmenu`, 'recycle_staff'],
        ['06_foodwaste_staff_portal.png', `${BASE_URL}/accessmenu`, 'food_staff'],
        ['07_citizen_portal.png', `${BASE_URL}/accessmenu`, 'citizen']
    ], 'user_portals');

    // 2. Admin Management
    await runBatch('[2/6] Admin Management Domain', [
        ['08_admin_users_index.png', `${BASE_URL}/admin/users`],
        ['09_admin_users_create.png', `${BASE_URL}/admin/users/create`],
        ['10_admin_zones_index.png', `${BASE_URL}/admin/zone`],
        ['11_admin_roles_index.png', `${BASE_URL}/admin/roles`],
        ['12_admin_permissions_index.png', `${BASE_URL}/admin/permissions`],
        ['13_admin_welfare_dashboard.png', `${BASE_URL}/admin/welfare/dashboard`],
        ['14_admin_financial_report.png', `${BASE_URL}/admin/financial`]
    ], 'admin');

    // 3. Tabwater Domain
    await runBatch('[3/6] Tabwater (การประปา) Domain', [
        ['15_tabwater_twmanmobile.png', `${BASE_URL}/twmanmobile`],
        ['16_tabwater_twmanmobile_main.png', `${BASE_URL}/twmanmobile/main`],
        ['17_tabwater_cutmeter_index.png', `${BASE_URL}/cutmeter`],
        ['18_tabwater_invoice_period.png', `${BASE_URL}/admin/invoice_period`],
        ['19_tabwater_stations_index.png', `${BASE_URL}/tabwater/settings/stations`],
        ['20_tabwater_pipelines_index.png', `${BASE_URL}/tabwater/settings/pipelines`]
    ], 'admin');

    // 4. KeptKaya Domain
    await runBatch('[4/6] KeptKaya (ธนาคารขยะและขยะทั่วไป) Domain', [
        ['21_keptkaya_dashboard.png', `${BASE_URL}/keptkayas/dashboard`],
        ['22_keptkaya_members.png', `${BASE_URL}/keptkayas/recycle-bank/members`],
        ['23_keptkaya_korkor3_report.png', `${BASE_URL}/keptkayas/korkor3`],
        ['24_keptkaya_tbank_items.png', `${BASE_URL}/keptkayas/tbank/items`],
        ['25_keptkaya_tbank_prices.png', `${BASE_URL}/keptkayas/tbank/prices`],
        ['26_keptkaya_tbank_units.png', `${BASE_URL}/keptkayas/tbank/units`],
        ['27_keptkaya_annual_payments.png', `${BASE_URL}/keptkayas/annual-payments`]
    ], 'admin');

    // 5. FoodWaste Domain
    await runBatch('[5/6] FoodWaste (ขยะอินทรีย์) Domain', [
        ['28_foodwaste_executive_dashboard.png', `${BASE_URL}/foodwaste/exec-dashboard`],
        ['29_foodwaste_staff_dashboard.png', `${BASE_URL}/foodwaste/dashboard`],
        ['30_foodwaste_admin_issues.png', `${BASE_URL}/foodwaste/admin/issues`],
        ['31_foodwaste_admin_issue_types.png', `${BASE_URL}/foodwaste/admin/issue-types`],
        ['32_foodwaste_iotboxes.png', `${BASE_URL}/foodwaste/iotboxes`],
        ['33_foodwaste_local_foods.png', `${BASE_URL}/foodwaste/admin/local-foods`],
        ['34_foodwaste_members_waste.png', `${BASE_URL}/foodwaste/admin/members-waste`]
    ], 'food_staff');

    // 6. Inventory Domain
    await runBatch('[6/6] Inventory (คลังพัสดุและพัสดุ) Domain', [
        ['35_inventory_dashboard.png', `${BASE_URL}/inventory/dashboard`],
        ['36_inventory_items.png', `${BASE_URL}/inventory/items/index`],
        ['37_inventory_categories.png', `${BASE_URL}/inventory/categories`],
        ['38_inventory_locations.png', `${BASE_URL}/inventory/locations/index`],
        ['39_inventory_suppliers.png', `${BASE_URL}/admin/suppliers`]
    ], 'admin');

    console.log('\n===============================================================');
    console.log('ALL 39 E2E SCREENSHOTS VERIFIED AND CAPTURED SUCCESSFULLY!');
    console.log('===============================================================');
}

main().catch(err => {
    console.error('Fatal error during E2E capture:', err);
    process.exit(1);
});
