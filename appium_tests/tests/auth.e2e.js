const assert = require('assert');
const {
  handleOnboardingIfPresent,
  ensureSignupScreen,
  fillSignup,
  submitSignup,
  waitForHome,
  uniqueEmail,
  screenType
} = require('./helpers');

describe('Auth E2E', () => {
  it('Open app → signup → reach Home screen', async () => {
    await handleOnboardingIfPresent(70000);

    // 1) Navigate to Signup
    const okSignupNav = await ensureSignupScreen(70000);
    assert.ok(okSignupNav, `Could not navigate to Signup screen from Get Started. Current=${await screenType()}`);

    // 2) Fill + submit signup
    const email = uniqueEmail('laza');
    const password = process.env.TEST_PASSWORD || 'P@ssw0rd123';

    const okFill = await fillSignup('Appium Test User', email, password);
    assert.ok(okFill, `Could not fill signup fields. Current=${await screenType()}`);

    const okSubmit = await submitSignup();
    assert.ok(okSubmit, `Could not submit signup. Current=${await screenType()}`);

    // 3) ✅ PASS condition:
    // Home is considered reached if ANY of these appears:
    // - home_screen (if exposed)
    // - bottom nav semantics: tab_home/tab_favorites/open_cart_btn/tab_profile
    const okHome = await waitForHome(90000);
    assert.ok(okHome, `Home screen not reached after signup. Current=${await screenType()}`);
  });
});
