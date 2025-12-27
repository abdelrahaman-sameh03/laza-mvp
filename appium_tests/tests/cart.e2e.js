const assert = require('assert');

const {
  waitForScreen,
  screenType,
  isDisplayed,
  fillSignup,
  submitSignup,
  fillLogin,
  submitLogin,
  dismissKeyboard,
  uiTextContains,
  uiDescriptionContains,
} = require('./helpers');

async function handleOnboardingIfPresent() {
  // Onboarding page has no accessibility ids; rely on visible text.
  try {
    const title = await browser.$(uiTextContains('Look Good, Feel Good'));
    if (!(await title.isDisplayed())) return false;

    const skip = await browser.$(uiTextContains('Skip'));
    if (await skip.isDisplayed()) {
      await skip.click();
      await browser.pause(500);
      return true;
    }

    const women = await browser.$(uiTextContains('Women'));
    if (await women.isDisplayed()) {
      await women.click();
      await browser.pause(500);
      return true;
    }

    return false;
  } catch (_) {
    return false;
  }
}

async function ensureHomeReady() {
  const creds = {
    name: 'Cart Test User',
    email: `laza_${Date.now()}@example.com`,
    password: 'P@ssw0rd123',
  };

  await browser.pause(800);

  for (let i = 0; i < 12; i++) {
    await handleOnboardingIfPresent();

    const st = await screenType();
    if (st === 'home') return creds;

    if (st === 'get_started') {
      if (await isDisplayed('~go_to_signup_btn')) {
        await (await $('~go_to_signup_btn')).click();
      } else {
        const create = await browser.$(uiTextContains('Create an Account'));
        await create.waitForDisplayed({ timeout: 20000 });
        await create.click();
      }
      await browser.pause(800);
      continue;
    }

    if (st === 'signup') {
      await fillSignup(creds);
      await dismissKeyboard();
      await submitSignup();
      await waitForScreen(['home', 'login', 'onboarding'], 30000);
      continue;
    }

    if (st === 'login') {
      await fillLogin(creds.email, creds.password);
      await dismissKeyboard();
      await submitLogin();
      await waitForScreen(['home', 'onboarding'], 30000);
      continue;
    }

    // Unknown state, give the app time then retry
    await browser.pause(1200);
  }

  throw new Error(`Could not reach Home. Last screen=${await screenType()}`);
}

async function openFirstProductFromHome() {
  const firstCard = await browser.$(uiDescriptionContains('product_card_'));
  await firstCard.waitForDisplayed({ timeout: 60000 });
  await firstCard.click();
}

async function addCurrentProductToCart() {
  const addBtn = await $('~add_to_cart_btn');
  await addBtn.waitForDisplayed({ timeout: 30000 });
  await addBtn.click();
  await browser.pause(800);
}

async function backToHome() {
  await browser.back();
  await waitForScreen(['home'], 30000);
}

async function openCartTab() {
  const cartTab = await $('~open_cart_btn');
  await cartTab.waitForDisplayed({ timeout: 30000 });
  await cartTab.click();
}

async function assertCartOpened() {
  if (await isDisplayed('~cart_screen')) return;
  const title = await browser.$(uiTextContains('Cart'));
  await title.waitForDisplayed({ timeout: 30000 });
}

describe('Cart E2E', () => {
  it('Open app → signup (if needed) → open product → add to cart → open cart', async () => {
    await ensureHomeReady();

    assert.strictEqual(
      await screenType(),
      'home',
      `Home not ready before starting cart flow. Current=${await screenType()}`,
    );

    await openFirstProductFromHome();
    await addCurrentProductToCart();
    await backToHome();
    await openCartTab();
    await assertCartOpened();
  });
});
