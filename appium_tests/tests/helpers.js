/**
 * Robust helpers for Flutter apps on Android emulator (Appium + UiAutomator2).
 *
 * Key point for Flutter:
 *  - Many visible strings appear in **content-desc** (accessibility) rather than native "text".
 *  - So we must search by BOTH: textContains(...) AND descriptionContains(...).
 */

async function waitAndTap(selector, timeout = 20000) {
  const el = await browser.$(selector);
  await el.waitForDisplayed({ timeout });
  await el.click();
}

async function waitAndSetValue(selector, value, timeout = 20000) {
  const el = await browser.$(selector);
  await el.waitForDisplayed({ timeout });
  await el.setValue(value);
}


async function dismissKeyboard() {
  // On Android emulator, the keyboard often blocks bottom buttons.
  try {
    // webdriverio expose hideKeyboard sometimes
    if (browser.hideKeyboard) {
      await browser.hideKeyboard();
      await browser.pause(300);
      return true;
    }
  } catch (_) {}

  // Fallback: press Back once (usually hides keyboard if it's open)
  try {
    await browser.back();
    await browser.pause(300);
    return true;
  } catch (_) {}

  return false;
}

async function tapAt(x, y) {
  // Try Appium clickGesture
  try {
    await browser.execute('mobile: clickGesture', { x, y });
    await browser.pause(300);
    return true;
  } catch (_) {}

  // W3C actions fallback
  try {
    await browser.performActions([{
      type: 'pointer',
      id: 'finger1',
      parameters: { pointerType: 'touch' },
      actions: [
        { type: 'pointerMove', duration: 0, x, y },
        { type: 'pointerDown', button: 0 },
        { type: 'pause', duration: 80 },
        { type: 'pointerUp', button: 0 }
      ]
    }]);
    await browser.releaseActions();
    await browser.pause(300);
    return true;
  } catch (_) {}

  return false;
}

async function tapRelative(px, py) {
  const rect = await browser.getWindowRect();
  const x = Math.floor(rect.width * px);
  const y = Math.floor(rect.height * py);
  return tapAt(x, y);
}

async function swipeUp(percentage = 0.55) {
  // swipe from 80% of screen to (80%-percentage) of screen
  const rect = await browser.getWindowRect();
  const startX = Math.floor(rect.width / 2);
  const startY = Math.floor(rect.height * 0.80);
  const endY = Math.floor(rect.height * (0.80 - percentage));

  // Try Appium gesture first
  try {
    await browser.execute('mobile: swipeGesture', {
      left: 0,
      top: 0,
      width: rect.width,
      height: rect.height,
      direction: 'up',
      percent: 0.6
    });
    await browser.pause(400);
    return true;
  } catch (_) {}

  // W3C actions fallback
  try {
    await browser.performActions([{
      type: 'pointer',
      id: 'finger1',
      parameters: { pointerType: 'touch' },
      actions: [
        { type: 'pointerMove', duration: 0, x: startX, y: startY },
        { type: 'pointerDown', button: 0 },
        { type: 'pause', duration: 100 },
        { type: 'pointerMove', duration: 350, x: startX, y: endY },
        { type: 'pointerUp', button: 0 }
      ]
    }]);
    await browser.releaseActions();
    await browser.pause(400);
    return true;
  } catch (_) {}

  return false;
}

async function tapElementCenter(el) {
  const rect = await el.getRect();
  const x = Math.floor(rect.x + rect.width / 2);
  const y = Math.floor(rect.y + rect.height / 2);

  // Try Appium clickGesture
  try {
    await browser.execute('mobile: clickGesture', { x, y });
    return true;
  } catch (_) {}

  // W3C actions fallback
  try {
    await browser.performActions([{
      type: 'pointer',
      id: 'finger2',
      parameters: { pointerType: 'touch' },
      actions: [
        { type: 'pointerMove', duration: 0, x, y },
        { type: 'pointerDown', button: 0 },
        { type: 'pause', duration: 60 },
        { type: 'pointerUp', button: 0 }
      ]
    }]);
    await browser.releaseActions();
    return true;
  } catch (_) {}

  return false;
}


async function isDisplayed(selector) {
  const el = await browser.$(selector);
  return (await el.isExisting()) && (await el.isDisplayed());
}

function uiTextContains(s) {
  return `android=new UiSelector().textContains("${s}")`;
}

function uiDescContains(s) {
  return `android=new UiSelector().descriptionContains("${s}")`;
}

async function findByTextOrDescContains(s) {
  const byDesc = await browser.$(uiDescContains(s));
  if (await byDesc.isExisting()) return byDesc;

  const byText = await browser.$(uiTextContains(s));
  if (await byText.isExisting()) return byText;

  // also try exact accessibility-id match (content-desc exact)
  const byAcc = await browser.$(`~${s}`);
  if (await byAcc.isExisting()) return byAcc;

  return null;
}

async function isStringDisplayed(s) {
  const el = await findByTextOrDescContains(s);
  if (!el) return false;
  return (await el.isDisplayed());
}

async function tapString(s, timeout = 20000) {
  const start = Date.now();
  while (Date.now() - start < timeout) {
    const el = await findByTextOrDescContains(s);
    if (el && (await el.isExisting())) {
      try {
        if (!(await el.isDisplayed())) {
          await browser.pause(250);
          continue;
        }
        await el.click();
        return true;
      } catch (_) {}
    }
    await browser.pause(300);
  }
  return false;
}

async function visibleEditTexts() {
  const els = await browser.$$(`android=new UiSelector().className("android.widget.EditText")`);
  const vis = [];
  for (const e of els) {
    try { if (await e.isDisplayed()) vis.push(e); } catch (_) {}
  }
  return vis;
}

async function visibleEditTextCount() {
  return (await visibleEditTexts()).length;
}

async function screenType() {
  // NOTE: Do NOT rely only on Semantics labels – Flutter accessibility nodes can be inconsistent.
  // We detect screens using a mix of stable UI texts, field counts, and (if available) Semantics ids.

  // --- HOME ---
  if (
    (await isDisplayed('~home_screen')) ||
    (await isDisplayed('~tab_home')) ||
    (await isDisplayed('~tab_profile')) ||
    (await isDisplayed('~open_cart_btn'))
  ) {
    return 'home';
  }

  // Home has a search field and bottom tabs (Home/Fav/Cart/Profile) – very stable.
  const hasSearch = await isStringDisplayed('Search');
  const hasWelcomeToLaza = await isStringDisplayed('Welcome to Laza');
  const hasBottomTabs =
    (await isStringDisplayed('Home')) &&
    (await isStringDisplayed('Fav')) &&
    (await isStringDisplayed('Cart')) &&
    (await isStringDisplayed('Profile'));

  if (hasSearch || hasWelcomeToLaza || hasBottomTabs) return 'home';

  // --- ONBOARDING (gender selection screen) ---
  // Some Flutter texts are not exposed as native widgets; detect by visible strings.
  const hasLookGood = await isStringDisplayed('Look Good, Feel Good');
  const hasWomen = await isStringDisplayed('Women');
  const hasMen = await isStringDisplayed('Men');
  const hasSkip = await isStringDisplayed('Skip');
  if (hasLookGood || (hasWomen && hasMen) || hasSkip) return 'onboarding';


  // --- GET STARTED ---
  if (
    (await isDisplayed('~get_started_screen')) ||
    (await isStringDisplayed("Let's Get Started")) ||
    (await isStringDisplayed('Create an Account'))
  ) {
    return 'get_started';
  }

  // --- SIGNUP ---
  const editCount = await visibleEditTextCount(); // signup: usually 3, login: usually 2, home: usually 1
  if (
    (await isDisplayed('~signup_screen')) ||
    (await isDisplayed('~signup_submit')) ||
    ((await isStringDisplayed('Sign Up')) && editCount >= 2)
  ) {
    return 'signup';
  }

  // --- LOGIN ---
  if (
    (await isDisplayed('~login_screen')) ||
    (await isDisplayed('~login_submit')) ||
    (((await isStringDisplayed('Login')) || (await isStringDisplayed('Welcome'))) && editCount >= 1)
  ) {
    return 'login';
  }

  return 'unknown';
}


async function waitForScreen(types, timeout = 70000) {
  const start = Date.now();
  while (Date.now() - start < timeout) {
    const t = await screenType();
    if (types.includes(t)) return t;
    await browser.pause(400);
  }
  return await screenType();
}

async function handleOnboardingIfPresent(timeout = 70000) {
  const t = await waitForScreen(['onboarding','get_started','login','signup','home'], timeout);
  if (t !== 'onboarding') return false;

  // Try to tap via semantics id (if implemented) or by visible text
  const candidates = ['~onboarding_women_btn','Women','~onboarding_men_btn','Men','Skip'];
  for (const c of candidates) {
    if (c.startsWith('~')) {
      if (await isDisplayed(c)) { await waitAndTap(c, 20000); await browser.pause(700); return true; }
    } else {
      if (await tapString(c, 12000)) { await browser.pause(700); return true; }
    }
  }

  // Fallback: tap approximate "Women" button location (right button in the card)
  // Works on most emulator sizes because it's relative to screen.
  try {
    await tapRelative(0.72, 0.78); // Women button
    await browser.pause(900);
    return true;
  } catch (_) {}

  // Final fallback: tap Skip text location
  try {
    await tapRelative(0.50, 0.86);
    await browser.pause(900);
    return true;
  } catch (_) {}

  return false;
}

async function ensureSignupScreen(timeout = 70000) {
  const start = Date.now();
  while (Date.now() - start < timeout) {
    const t = await screenType();
    if (t === 'signup') return true;

    if (t === 'onboarding') {
      await handleOnboardingIfPresent(20000);
      continue;
    }

    if (t === 'get_started') {
      // Prefer explicit semantics id if exists
      if (await isDisplayed('~go_to_signup_btn')) {
        await waitAndTap('~go_to_signup_btn', 30000);
      } else {
        // Flutter often exposes this label via content-desc
        const ok = await tapString('Create an Account', 30000);
        if (!ok) {
          // sometimes text is "Create Account"
          await tapString('Create Account', 8000);
        }
      }
      await browser.pause(900);

      // wait until we actually arrive
      const after = await waitForScreen(['signup','login','get_started'], 15000);
      if (after === 'signup') return true;
      // if we landed on login by mistake, continue loop and handle login case
      continue;
    }

    if (t === 'login') {
      // on login page: try a signup link, else back
      if (await tapString('Create an Account', 5000)) { await browser.pause(800); continue; }
      if (await tapString('Sign up', 5000)) { await browser.pause(800); continue; }
      if (await tapString('Register', 5000)) { await browser.pause(800); continue; }
      await browser.back();
      await browser.pause(900);
      continue;
    }

    // unknown: wait a bit
    await browser.pause(600);
  }
  return false;
}

async function ensureLoginScreen(timeout = 70000) {
  const start = Date.now();
  while (Date.now() - start < timeout) {
    const t = await screenType();
    if (t === 'login') return true;

    if (t === 'onboarding') {
      await handleOnboardingIfPresent(20000);
      continue;
    }

    if (t === 'get_started') {
      if (await isDisplayed('~go_to_login_btn')) {
        await waitAndTap('~go_to_login_btn', 30000);
      } else {
        // Your UI uses "Signin"
        const ok = await tapString('Signin', 30000);
        if (!ok) await tapString('Sign in', 8000);
      }
      await browser.pause(900);
      const after = await waitForScreen(['login','signup','get_started'], 15000);
      if (after === 'login') return true;
      continue;
    }

    if (t === 'signup') {
      if (await tapString('Signin', 5000)) { await browser.pause(800); continue; }
      if (await tapString('Sign in', 5000)) { await browser.pause(800); continue; }
      await browser.back();
      await browser.pause(900);
      continue;
    }

    await browser.pause(600);
  }
  return false;
}

async function fillSignup(name, email, password) {
  if (await isDisplayed('~signup_email')) {
    await waitAndSetValue('~signup_name', name);
    await waitAndSetValue('~signup_email', email);
    await waitAndSetValue('~signup_password', password);

    const confirm = await browser.$('~signup_confirm_password');
    if (await confirm.isExisting()) {
      await confirm.waitForDisplayed({ timeout: 15000 });
      await confirm.setValue(password);
    }
    return true;
  }

  // fallback: EditTexts
  const fields = await visibleEditTexts();
  if (fields.length >= 3) {
    await fields[0].click(); await fields[0].setValue(name);
    await fields[1].click(); await fields[1].setValue(email);
    await fields[2].click(); await fields[2].setValue(password);
    if (fields.length >= 4) { await fields[3].click(); await fields[3].setValue(password); }
    return true;
  }
  return false;
}

async function submitSignup() {
  // Make sure the bottom button is not covered by keyboard
  await dismissKeyboard();
  await browser.pause(400);

  // Prefer Semantics id if it exists
  if (await isDisplayed('~signup_btn')) {
    const el = await browser.$('~signup_btn');
    try {
      await el.scrollIntoView?.();
    } catch (_) {}
    try { await el.click(); return true; } catch (_) { return await tapElementCenter(el); }
  }

  // Flutter may expose the button text via content-desc
  const candidates = ['Sign Up','Signup','Create Account','Create','Register','Continue'];
  for (const c of candidates) {
    // 1st try direct tap by string (text or description)
    if (await tapString(c, 2500)) return true;

    // If not found/clickable, try swiping up a bit then retry
    await swipeUp(0.45);
    if (await tapString(c, 2500)) return true;
  }

  return false;
}

async function fillLogin(email, password) {
  if (await isDisplayed('~login_email')) {
    await waitAndSetValue('~login_email', email);
    await waitAndSetValue('~login_password', password);
    return true;
  }

  const fields = await visibleEditTexts();
  if (fields.length >= 2) {
    await fields[0].click(); await fields[0].setValue(email);
    await fields[1].click(); await fields[1].setValue(password);
    return true;
  }
  return false;
}

async function submitLogin() {
  await dismissKeyboard();
  await browser.pause(400);

  if (await isDisplayed('~login_btn')) {
    const el = await browser.$('~login_btn');
    try { await el.click(); return true; } catch (_) { return await tapElementCenter(el); }
  }

  const candidates = ['Login','Log in','Sign in','Continue'];
  for (const c of candidates) {
    if (await tapString(c, 2500)) return true;
    await swipeUp(0.45);
    if (await tapString(c, 2500)) return true;
  }
  return false;
}

async function closeLoginFailedIfPresent() {
  if (await isStringDisplayed('Login failed')) {
    await tapString('OK', 8000);
    await browser.pause(600);
    return true;
  }
  return false;
}

async function waitForHome({ timeout = 90000 } = {}) {
  const start = Date.now();
  while (Date.now() - start < timeout) {
    const t = await screenType();
    if (t === 'home') return true;
    await browser.pause(500);
  }
  return false;
}


function uniqueEmail(prefix = 'test') {
  const stamp = Date.now();
  return `${prefix}_${stamp}@example.com`;
}
async function completeSignUp({ name, email, password } = {}) {
  const finalName = name || 'Appium Test User';
  const finalEmail = email || uniqueEmail();     // عندك already في helpers
  const finalPassword = password || 'P@ssw0rd123';

  // روح لصفحة Sign Up من Get Started
  await ensureSignupScreen();

  // املأ الداتا
  await fillSignup({
    name: finalName,
    email: finalEmail,
    password: finalPassword,
  });

  // اضغط Sign Up
  await submitSignup();

  // لو ظهر onboarding (Look Good, Feel Good) اقفله/skip
  await handleOnboardingIfPresent();

  return { email: finalEmail, password: finalPassword };
}

module.exports = {
  waitAndTap,
  waitAndSetValue,
  isDisplayed,
  isStringDisplayed,
  tapString,
  visibleEditTextCount,
  screenType,
  completeSignUp,
  waitForScreen,
  handleOnboardingIfPresent,
  ensureSignupScreen,
  ensureLoginScreen,
  fillSignup,
  submitSignup,
  fillLogin,
  submitLogin,
  closeLoginFailedIfPresent,
  waitForHome,
  uniqueEmail,
};
