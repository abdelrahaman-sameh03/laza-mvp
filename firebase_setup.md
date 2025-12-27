# Firebase Setup Guide (Flutter + Firebase)

This guide explains how to connect the Flutter app to Firebase (Auth + Firestore).

---

## 1) Create Firebase Project
1. Go to Firebase Console
2. Create a new project (or use an existing one)

---

## 2) Enable Authentication (Email/Password)
1. Firebase Console → Authentication → Sign-in method
2. Enable **Email/Password**
3. Save

---

## 3) Create Firestore Database
1. Firebase Console → Firestore Database
2. Create database
3. Choose a location (keep it consistent)
4. Start in **test mode** temporarily (optional), then apply rules in step 6

---

## 4) Add Android App to Firebase
1. Firebase Console → Project settings → Your apps → Add app → Android
2. Enter Android package name  
   - You can find it in:
     - `android/app/src/main/AndroidManifest.xml`
     - or `android/app/build.gradle` / `android/app/build.gradle.kts`
3. Download `google-services.json`
4. Place it here:
   `android/app/google-services.json`

---

## 5) Flutter Dependencies
From project root:
```bash
flutter pub get
```

---

## 6) Install Firestore Rules
This repo provides `firestore.rules`.

### Option A (Console)
1. Firebase Console → Firestore Database → Rules
2. Paste the content of `firestore.rules`
3. Publish

### Option B (Firebase CLI)
Install Firebase CLI, then:
```bash
firebase login
firebase use <your_project_id>
firebase deploy --only firestore:rules
```

---

## 7) Run the App
```bash
flutter run
```

---

## 8) Common Issues

### App not connecting to Firebase (Android)
- Ensure `google-services.json` is inside `android/app/`
- Re-run:
```bash
flutter clean
flutter pub get
flutter run
```

### Firestore permission denied
- Make sure the rules are published correctly
- Ensure the user is logged in before accessing user-scoped data
