const path = require('path');
const fs = require('fs');

const ROOT = path.resolve(__dirname, '..');
const RESULTS_DIR = process.env.RESULTS_DIR
  ? path.resolve(process.env.RESULTS_DIR)
  : path.resolve(ROOT, 'docs', 'results');

function ensureDir(p) {
  if (!fs.existsSync(p)) fs.mkdirSync(p, { recursive: true });
}

ensureDir(RESULTS_DIR);
ensureDir(path.join(RESULTS_DIR, 'logs'));
ensureDir(path.join(RESULTS_DIR, 'screenshots'));

/**
 * Configuration notes:
 * - Prefer passing APP to point to your built APK:
 *     Windows (PowerShell): $env:APP=".\apk\app-release.apk"
 *     macOS/Linux: export APP=./apk/app-release.apk
 * - Or you can use appPackage/appActivity (advanced).
 */
exports.config = {
  runner: 'local',
  hostname: process.env.APPIUM_HOST || '127.0.0.1',
  port: Number(process.env.APPIUM_PORT || 4723),
  path: process.env.APPIUM_PATH || '/',

  specs: ['./tests/**/*.e2e.js'],
  maxInstances: 1,

  logLevel: 'info',
  bail: 0,
  waitforTimeout: 20000,
  connectionRetryTimeout: 120000,
  connectionRetryCount: 2,

  framework: 'mocha',
  reporters: ['spec'],

  mochaOpts: {
    ui: 'bdd',
    timeout: 10 * 60 * 1000,
  },

  capabilities: [{
    platformName: 'Android',
    'appium:automationName': 'UiAutomator2',
    'appium:deviceName': process.env.DEVICE_NAME || 'Android Emulator',
    'appium:platformVersion': process.env.PLATFORM_VERSION || undefined,
    'appium:app': process.env.APP ? path.resolve(ROOT, process.env.APP) : undefined,

    // Keep fresh app state so signup/login behaves consistently
    'appium:noReset': false,
    'appium:fullReset': false,

    // Helps with Flutter app startup
    'appium:autoGrantPermissions': true,

    // Optional: if you prefer appPackage/appActivity:
    // 'appium:appPackage': process.env.APP_PACKAGE,
    // 'appium:appActivity': process.env.APP_ACTIVITY,
    // 'appium:appWaitActivity': process.env.APP_WAIT_ACTIVITY,
  }],

  /**
   * Save a screenshot on failure into /docs/results/screenshots
   */
  afterTest: async function (test, context, { error, passed }) {
    if (!passed) {
      const safeName = (test.title || 'test')
        .replace(/[^\w\d\-]+/g, '_')
        .slice(0, 120);
      const file = path.join(RESULTS_DIR, 'screenshots', `${safeName}.png`);
      await browser.saveScreenshot(file);
      console.log(`Saved failure screenshot: ${file}`);
    }
  },
};
