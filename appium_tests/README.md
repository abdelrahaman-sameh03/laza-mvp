# Appium E2E Tests (Auth + Cart)

This folder contains the required Appium end-to-end tests for the Flutter app.

## 1) Build the APK
From your Flutter project root:

```bash
flutter clean
flutter pub get
flutter build apk --debug
# or release:
flutter build apk --release
```

Your APK will typically be here:
- Debug: `build/app/outputs/flutter-apk/app-debug.apk`
- Release: `build/app/outputs/flutter-apk/app-release.apk`

Copy the APK into your repo root (example):
- `./apk/app-debug.apk` or `./apk/app-release.apk`

> Recommended repo layout:
>
> - `/appium_tests` (this folder)
> - `/apk/app-release.apk`
> - `/docs/results` (for logs/screenshots)

---

## 2) Install Appium + Driver
### Install Appium 2
```bash
npm install -g appium
```

### Install Android driver
```bash
appium driver install uiautomator2
```

Verify:
```bash
appium driver list
```

---

## 3) Start Android Emulator (or connect device)
- Start an emulator from Android Studio **Device Manager**
- OR connect a real device and enable USB Debugging

Check device list:
```bash
adb devices
```

---

## 4) Start Appium Server
```bash
appium
```

Default server:
- Host: `127.0.0.1`
- Port: `4723`

---

## 5) Install test dependencies
From repo root:
```bash
cd appium_tests
npm install
```

---

## 6) Configure environment variables
From repo root, set the APK path (relative to repo root).

### Windows PowerShell
```powershell
$env:APP="apk\app-release.apk"
```

### macOS/Linux
```bash
export APP=./apk/app-release.apk
```

Optional:
```bash
export DEVICE_NAME="Android Emulator"
export PLATFORM_VERSION="14"   # example
export TEST_PASSWORD="P@ssw0rd123"
```

---

## 7) Run Tests
### Run Auth test
```bash
npm run test:auth
```

### Run Cart test
```bash
npm run test:cart
```

### Run both
```bash
npm test
```

---

## 8) Results
- Failure screenshots are saved automatically to:
  - `../docs/results/screenshots/`
- You can also place Appium logs manually into:
  - `../docs/results/logs/`

---

## Troubleshooting
### "No product cards found"
Make sure Home has Semantics labels like:
- `product_card_<id>` (e.g., `product_card_12`)

### App opens but stays on splash
Increase the default timeout or add a wait for your first element.

### Need appPackage/appActivity
If your environment prefers appPackage/appActivity instead of APK path, edit `wdio.conf.js` and set:
- `APP_PACKAGE`, `APP_ACTIVITY`, and optionally `APP_WAIT_ACTIVITY`.
