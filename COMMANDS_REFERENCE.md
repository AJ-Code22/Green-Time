# GreenTime Kids - Quick Commands Reference

## 🚀 Running the App

### Windows Desktop
```bash
cd c:\Users\ajays\Downloads\hi
flutter run -d windows
```

### Android Emulator/Device
```bash
# List connected devices
flutter devices

# Run on specific device
flutter run -d <device-id>
flutter run -d emulator-5554

# Run with debug info
flutter run -d android -v
```

### Web (Chrome)
```bash
flutter run -d chrome
```

### iOS Simulator (Mac only)
```bash
flutter run -d ios
```

---

## 🧹 Cleaning & Rebuilding

### Full Clean
```bash
flutter clean
```

### Get Dependencies
```bash
flutter pub get
```

### Update Dependencies
```bash
flutter pub upgrade
```

### Upgrade Flutter Itself
```bash
flutter upgrade
```

### Check for Issues
```bash
flutter doctor
```

---

## 🏗️ Building for Release

### Android APK
```bash
flutter build apk --release
```

### Android App Bundle (Google Play)
```bash
flutter build appbundle --release
```

### iOS App
```bash
flutter build ios --release
```

### Windows Executable
```bash
flutter build windows --release
```

### Web Release
```bash
flutter build web --release
```

---

## 🔍 Debugging & Logging

### View Live Logs
```bash
flutter logs
```

### Run with Verbose Output
```bash
flutter run -v
```

### Run with Profiling
```bash
flutter run --profile
```

### Run in Release Mode
```bash
flutter run --release
```

### Check Static Analysis
```bash
flutter analyze
```

### Format Code
```bash
dart format lib/
# or
flutter format lib/
```

### Fix Linting Issues
```bash
dart fix --apply
```

---

## 📱 Device Management

### List All Devices
```bash
flutter devices
```

### Launch Android Emulator
```bash
# List emulators
flutter emulators

# Launch specific emulator
flutter emulators --launch emulator_name
```

### Kill All Devices/Emulators
```bash
flutter devices
# Then use device ID to target specific device
```

---

## 🔥 Firebase & Firestore

### Login to Firebase CLI
```bash
firebase login
```

### Deploy Firestore Rules
```bash
firebase deploy --only firestore:rules
```

### View Firebase Logs
```bash
firebase functions:log
```

### Start Emulator (Optional)
```bash
firebase emulators:start
```

---

## 📦 Dependency Management

### Add New Package
```bash
flutter pub add package_name
# Example: flutter pub add provider
```

### Remove Package
```bash
flutter pub remove package_name
```

### Check Outdated Packages
```bash
flutter pub outdated
```

### Get Specific Version
```bash
flutter pub add package_name:^1.0.0
```

---

## 🎨 Development Servers

### Hot Reload (During Development)
Press `r` in terminal during `flutter run`

### Full Hot Restart
Press `R` in terminal during `flutter run`

### Toggle Debug Info
Press `w` for widget info  
Press `d` for device info  
Press `p` for performance metrics  

### Stop Running App
Press `q` in terminal

---

## 📊 Project Info

### Get Project Info
```bash
flutter pub global activate devtools
devtools
```

### Check Flutter Version
```bash
flutter --version
```

### Check Dart Version
```bash
dart --version
```

### Check SDK Versions
```bash
flutter doctor -v
```

---

## 🧪 Testing

### Run Unit Tests
```bash
flutter test
```

### Run Specific Test File
```bash
flutter test test/file_test.dart
```

### Generate Coverage Report
```bash
flutter test --coverage
```

### View Coverage
```bash
# Install lcov if not present
# macOS: brew install lcov
# Windows: choco install lcov
lcov -l coverage/lcov.info
```

---

## 🚨 Common Issues & Quick Fixes

### "Flutter SDK not found"
```bash
# Set Flutter path
flutter config --flutter-root=/path/to/flutter

# Or add to PATH environment variable
```

### "Android SDK not found"
```bash
# Set Android SDK path
flutter config --android-sdk=/path/to/android/sdk

# Or in Android Studio: Tools → SDK Manager
```

### Build Cache Issues
```bash
flutter clean
flutter pub get
flutter pub upgrade
flutter build windows
```

### Gradle Issues (Android)
```bash
cd android
./gradlew clean
cd ..
flutter clean
flutter pub get
```

### WebView Not Loading
```bash
# Clear app cache
flutter clean

# Rebuild
flutter pub get
flutter run
```

### Real-time Sync Not Working
1. Check Firebase Console for security rules
2. Verify Firestore listeners are active
3. Check network connectivity
4. Review Android/iOS permissions

---

## 📁 File Locations

### Main App Code
```
lib/
```

### Assets (Images, Fonts)
```
assets/images/
assets/fonts/
```

### Android Configuration
```
android/app/build.gradle.kts
android/app/src/AndroidManifest.xml
```

### iOS Configuration
```
ios/Runner/Info.plist
ios/Runner/GeneratedPluginRegistrant.m
```

### Windows Configuration
```
windows/runner/main.cpp
```

### Web Configuration
```
web/index.html
web/manifest.json
```

### Firebase Configuration
```
lib/firebase_options.dart
google-services.json (Android)
GoogleService-Info.plist (iOS)
```

---

## 🔐 Security Commands

### Generate Release Signing Key (Android)
```bash
keytool -genkey -v -keystore release.keystore -keyalg RSA -keysize 2048 -validity 10000 -alias release
```

### Create Keystore Properties (Android)
```
# Create android/key.properties
storeFile=../release.keystore
storePassword=your_password
keyPassword=your_password
keyAlias=release
```

---

## 📚 Useful Documentation Links

### Within Project
- `DOCUMENTATION.md` - Full feature documentation
- `TESTING_GUIDE.md` - Testing procedures
- `STATUS_REPORT.md` - Project status
- `README.md` - Project overview

### External
- [Flutter Docs](https://flutter.dev/docs)
- [Firebase Docs](https://firebase.google.com/docs)
- [Dart Docs](https://dart.dev/guides)
- [Material Design 3](https://m3.material.io/)

---

## 💡 Development Tips

### Enable Web Support
```bash
flutter config --enable-web
```

### Enable Linux Desktop
```bash
flutter config --enable-linux-desktop
```

### Enable macOS Desktop
```bash
flutter config --enable-macos-desktop
```

### Enable Windows Desktop
```bash
flutter config --enable-windows-desktop
```

### View All Config Options
```bash
flutter config
```

### Use a Different Channel
```bash
# Change to beta
flutter channel beta
flutter upgrade

# Change back to stable
flutter channel stable
flutter upgrade
```

---

## 🎯 Quick Development Workflow

### 1. Start Development
```bash
cd c:\Users\ajays\Downloads\hi
flutter clean
flutter pub get
flutter run -d windows
```

### 2. Make Changes
- Edit files in `lib/` directory
- Save changes (auto hot-reload in terminal)
- Press `r` for hot reload
- Press `R` for full restart

### 3. Test Changes
- Follow `TESTING_GUIDE.md`
- Check `flutter logs` for errors
- Press `w` for widget inspection

### 4. Before Committing
```bash
dart format lib/
flutter analyze
```

### 5. Build for Deployment
```bash
flutter clean
flutter pub get
flutter build windows --release
# or android/web/ios as needed
```

---

## 🆘 Getting Help

### Check Status
```bash
flutter doctor -v
```

### View Documentation
```bash
flutter docs
```

### Check Issues
```bash
flutter analyze
flutter test
```

### Get Version Info
```bash
flutter --version
dart --version
```

### Create Issue Report
```bash
flutter logs > flutter_logs.txt
# Attach this file when reporting issues
```

---

## ⚡ Performance Tips

### Lightweight Development Build
```bash
flutter run --debug
```

### Profile Mode (Production-like with profiling)
```bash
flutter run --profile
```

### Release Mode (Fastest, no debugging)
```bash
flutter run --release
```

### Check Build Size
```bash
flutter build apk --split-per-abi --analyze-size
```

---

## 🔄 Continuous Integration Preparation

### Lint Before Commit
```bash
flutter analyze lib/
dart format lib/ --line-length=100
```

### Run Tests
```bash
flutter test
```

### Build for Verification
```bash
flutter build apk --debug
flutter build web --release
flutter build windows --release
```

---

## 📝 Notes

- Always run `flutter pub get` after pulling updates
- Use `flutter clean` before major builds
- Keep `flutter` and `dart` updated
- Check Firebase Console for data issues
- Use `flutter logs` for debugging
- Press `h` during `flutter run` for all hotkey options

---

**Remember:** For detailed instructions, see:
- `DOCUMENTATION.md` - Complete feature guide
- `TESTING_GUIDE.md` - Comprehensive testing procedures
- `STATUS_REPORT.md` - Project status and next steps

---

Last Updated: November 11, 2025
