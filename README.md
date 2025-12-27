# Laza MVP (Flutter + Firebase)

## Link for Video & apk:
https://drive.google.com/drive/folders/10I7Jl3aGRKRvUtQq9dUkZ0rz3q-CsiIG?usp=drive_link

## Project Overview
This repository contains a Flutter mobile application that demonstrates a basic e-commerce flow:
- User authentication (Signup/Login)
- Browsing products
- Product details
- Favorites (add/remove)
- Cart (add/view)
- Mock checkout flow
- Logout

The project also includes Appium end-to-end test scripts and test result artifacts.

---

## Tech Stack
- Flutter (Dart)
- Firebase Authentication (Email/Password)
- Cloud Firestore (users, carts, favorites)
- Appium (E2E testing)
- Node.js (for Appium test runner)

---

## How to Install Flutter & Project Dependencies

### 1) Install Flutter
Follow the official Flutter installation guide for your OS:
- Install Flutter SDK
- Add Flutter to PATH
- Install Android Studio + Android SDK
- Setup an emulator or connect a real device

Verify installation:
```bash
flutter --version
flutter doctor
```

### 2) Get Project Dependencies
From the project root:
```bash
flutter pub get
```

---

## Firebase Setup Steps
Follow the full guide in: **firebase_setup.md**

Quick summary:
1. Create a Firebase project
2. Enable Email/Password authentication
3. Create Firestore database
4. Add Android app to Firebase (package name)
5. Download `google-services.json` and place it in:
   `android/app/google-services.json`
6. Run the app

---

## Firestore Rules Installation
This repository includes a `firestore.rules` file.

### Option A (Console)
1. Firebase Console → Firestore Database → Rules
2. Copy/paste the content of `firestore.rules`
3. Publish

### Option B (Firebase CLI)
If you use Firebase CLI:
```bash
firebase login
firebase use <your_project_id>
firebase deploy --only firestore:rules
```

---

## How to Run Android

### Run on Emulator / Device
```bash
flutter run
```

### Build Release APK
```bash
flutter build apk --release
```

Output (default):
`build/app/outputs/flutter-apk/app-release.apk`

---

## How to Run Appium Tests

### Prerequisites
- Node.js installed
- Appium installed
- Android SDK installed
- Android emulator/device available
- App installed on the device/emulator

### Install Appium Test Dependencies
If your Appium tests use Node dependencies (package.json inside `appium_tests`):
```bash
cd appium_tests
npm install
```

### Start Appium Server
```bash
appium
```

### Run Tests
> Note: The exact command depends on your test runner setup (npm scripts).

Common examples:
```bash
cd appium_tests
npm test
```

Or run a specific test file:
```bash
node tests/auth.e2e.js
node tests/cart.e2e.js
```

### Test Results
Test outputs (logs + screenshots + summary) are stored in:
`docs/results/`

---

## Repository Structure (Deliverables)
- `/lib` Flutter source code  
- `/assets` Assets  
- `/test` Unit/widget tests (if any)  
- `/appium_tests` Appium scripts + test_cases.md  
- `/docs/results` Appium logs + screenshots + test summary  
- `/screenshots` App screenshots (manual)  
- `/builds/apk` Build artifacts (APK)  
- `/video` Screen recording (MP4)  

---


