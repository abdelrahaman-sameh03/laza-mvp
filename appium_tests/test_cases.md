# Appium Test Cases (Required)

This folder contains the **two required end-to-end Appium tests**:
1) **Auth Test** (Signup → Login → Home)
2) **Cart Test** (Open product → Add to cart → Open cart → Validate item)

> These tests rely on Flutter **Semantics labels** (Accessibility IDs) that were added to the UI.

---

## Tools & Versions (Recommended)
- **Node.js**: 18+ (LTS)
- **Java JDK**: 11+ (for Android tooling)
- **Android Studio**: installed + SDK + Emulator
- **Appium Server**: Appium 2.x
- **Appium Driver**: `uiautomator2`
- **Test Runner**: WebdriverIO + Mocha

---

## Pre-conditions
- Android Emulator running **OR** real Android device connected with USB debugging enabled
- Appium server running on `http://127.0.0.1:4723`
- You built an APK and you know its path
- Firebase configured and app can run normally

---

## Test Case 1: Auth Test

### Description
Open app → Signup → (Logout if needed) → Login → Validate navigation to Home

### Accessibility IDs Used
- `go_to_signup_btn`
- `signup_name`
- `signup_email`
- `signup_password`
- `signup_confirm_password` (optional)
- `signup_btn`
- `go_to_login_btn` (if present)
- `login_email`
- `login_password`
- `login_btn`
- `home_screen`
- `tab_profile` (optional)
- `logout_btn` (optional)

### Steps
1. Launch app
2. Tap **Get Started → Signup**
3. Fill name, email, password
4. Tap **Signup**
5. (Optional) Logout
6. Navigate to **Login**
7. Fill email, password
8. Tap **Login**
9. Verify Home is displayed (`home_screen`)

### Expected Result
- The app navigates successfully to the Home screen.

---

## Test Case 2: Cart Test

### Description
Open a product → Add to cart → Open cart → Validate the item appears

### Accessibility IDs Used
- `home_screen`
- `product_card_<id>`
- `add_to_cart_btn`
- `open_cart_btn`
- `cart_screen`
- `cart_item_<id>`

### Steps
1. Launch app and reach Home
2. Tap first product card (`product_card_<id>`)
3. Tap **Add to Cart**
4. Tap **Cart** tab (`open_cart_btn`)
5. Verify cart screen is shown (`cart_screen`)
6. Verify item exists (`cart_item_<id>`)

### Expected Result
- The selected product appears inside the cart.

---

## How to Run (Summary)
1. Start emulator/device
2. Start Appium server
3. Install dependencies:
   - `cd appium_tests`
   - `npm install`
4. Set APK path (example):
   - Windows PowerShell: `$env:APP="apk\app-release.apk"`
   - macOS/Linux: `export APP=./apk/app-release.apk`
5. Run:
   - Auth: `npm run test:auth`
   - Cart: `npm run test:cart`


---

## Note about Splash/Onboarding
The app opens on **Splash** then navigates to **Onboarding** (Men/Women). The tests handle this automatically by selecting **Women** (or Men fallback) before continuing.
