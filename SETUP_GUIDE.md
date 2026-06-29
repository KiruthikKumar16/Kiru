# 🛠️ Kiru Project Full Setup Guide

---

## Prerequisites to Install First

### 1. Flutter SDK (3.x or later)
#### Windows Installation:
1. Download Flutter SDK: https://flutter.dev/docs/get-started/install/windows
2. Extract zip to `C:\flutter`
3. Add `C:\flutter\bin` to your **System PATH** environment variable
4. Verify installation:
   ```powershell
   flutter --version
   ```

#### macOS Installation:
1. Download Flutter SDK: https://flutter.dev/docs/get-started/install/macos
2. Extract to `~/development/flutter`
3. Add to PATH in `.zshrc` or `.bashrc`:
   ```bash
   export PATH="$PATH:$HOME/development/flutter/bin"
   ```
4. Verify:
   ```bash
   flutter --version
   ```

#### Run Flutter Doctor to Check Dependencies:
```bash
flutter doctor
```
Fix any issues it reports (Android Studio, Xcode, etc.)

---

### 2. Android Studio / VS Code
- **Android Studio**: For Android emulators & build tools (required)
- **VS Code**: Optional but recommended, with Flutter extension installed

---

### 3. Firebase CLI
Install Firebase CLI:
```bash
npm install -g firebase-tools
# Or via standalone binary: https://firebase.google.com/docs/cli
```

---

### 4. Git
- Install from https://git-scm.com/

---

## Project Setup (After Installing Prerequisites)

### Step 1: Clone the repo
```bash
git clone https://github.com/KiruthikKumar16/Kiru.git
cd Kiru
```

### Step 2: Install Flutter dependencies
```bash
flutter pub get
```

### Step 3: Firebase Setup (CRITICAL)
1. Go to https://console.firebase.google.com/
2. Create a new project named **Kiru**
3. Enable these Firebase products:
   - Authentication (Email/Password + Google)
   - Firestore Database
   - Storage
   - Analytics
   - Cloud Messaging (FCM, optional for Phase 1)
4. **Android Setup**:
   - Add Android app to Firebase project
   - Download `google-services.json`
   - Place in `android/app/`
5. **iOS Setup**:
   - Add iOS app to Firebase project
   - Download `GoogleService-Info.plist`
   - Add to `ios/Runner/` via Xcode

---

### Step 4: Environment Variables
Create `.env` file in project root:
```env
GEMINI_API_KEY=your_google_gemini_api_key_here
WEATHER_API_KEY=your_openweathermap_api_key_here
```

#### How to Get API Keys:
1. **Gemini API Key**: https://aistudio.google.com/app/apikey
2. **OpenWeatherMap API Key**: https://home.openweathermap.org/users/sign_up

---

### Step 5: Run the App!
```bash
flutter run
```

---

## Optional: Enable Code Generation (Riverpod, Hive)
If you make changes to annotated files, run:
```bash
dart run build_runner watch --delete-conflicting-outputs
```

---

## Troubleshooting
- **Flutter not found**: Make sure Flutter is in your system PATH and restart your terminal
- **Firebase issues**: Double-check `google-services.json`/`GoogleService-Info.plist` are in correct directories
- **Build errors**: Run `flutter clean` then `flutter pub get` again

---

## Need Help?
Refer to project planning docs or ask the team! 🚀
