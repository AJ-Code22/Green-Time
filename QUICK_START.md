# 🚀 GreenTime Kids - Quick Start Guide (5 Minutes)

## Your 5-Minute Getting Started Guide

### Step 1: Open Terminal (30 seconds)
```bash
cd c:\Users\ajays\Downloads\hi
```

### Step 2: Verify Setup (1 minute)
```bash
flutter clean
flutter pub get
```
**Should see:** "Got dependencies!"

### Step 3: Run the App (1 minute)
```bash
flutter run -d windows
```
**Should see:** App launches on your screen

### Step 4: Test Basic Features (2 minutes)
1. [ ] App appears without errors
2. [ ] See login screen
3. [ ] Theme toggle button visible
4. [ ] Click theme toggle (light/dark switch)
5. [ ] Colors change correctly

### Step 5: Next Steps (30 seconds)
- ✅ Congratulations! App is running!
- 📖 Read [COMPLETION_SUMMARY.md](COMPLETION_SUMMARY.md) for overview
- 🧪 Use [TESTING_CHECKLIST.md](TESTING_CHECKLIST.md) for full testing

---

## 🎯 Common Commands (Quick Reference)

| Task | Command |
|------|---------|
| Run on Windows | `flutter run -d windows` |
| Run on Android | `flutter run -d android` |
| Run on Web | `flutter run -d chrome` |
| Stop app | Press `q` |
| Hot reload | Press `r` |
| Full restart | Press `R` |
| View logs | `flutter logs` |
| Clean & rebuild | `flutter clean && flutter pub get` |

---

## 🧪 What You Can Test Right Now

✅ **App Launch**
- [ ] App starts without errors
- [ ] Home screen displays

✅ **Theme System**
- [ ] Light mode looks good
- [ ] Toggle to dark mode works
- [ ] Dark colors look good

✅ **Basic Navigation**
- [ ] Can navigate between screens
- [ ] Back button works
- [ ] No crashes

✅ **Responsive Design**
- [ ] App responsive to window resize
- [ ] UI looks good on small window
- [ ] UI looks good on large window

---

## 📁 Key Files to Know

| File | What It Does |
|------|-------------|
| `lib/main.dart` | App starts here |
| `lib/theme/app_theme.dart` | Colors and styling |
| `lib/Screens/` | All the app screens |
| `lib/services/` | Behind-the-scenes logic |
| `pubspec.yaml` | All dependencies listed |

---

## 🆘 If Something Goes Wrong

### App Won't Start
```bash
flutter clean
flutter pub get
flutter run -d windows
```

### Dependencies Not Installing
```bash
flutter pub upgrade
flutter pub get
```

### Still Stuck?
1. Check `flutter doctor` output
2. See [COMMANDS_REFERENCE.md](COMMANDS_REFERENCE.md)
3. Read [DOCUMENTATION.md](DOCUMENTATION.md) troubleshooting

---

## 📖 After This Quick Start

1. **Want Overview?** → Read [COMPLETION_SUMMARY.md](COMPLETION_SUMMARY.md)
2. **Ready to Test?** → Use [TESTING_CHECKLIST.md](TESTING_CHECKLIST.md)
3. **Need Help?** → See [DOCUMENTATION_INDEX.md](DOCUMENTATION_INDEX.md)
4. **Want Details?** → Check [DOCUMENTATION.md](DOCUMENTATION.md)

---

## ✅ Success Checklist

- [ ] App launched without errors
- [ ] Login screen visible
- [ ] Theme toggle works
- [ ] Light/dark modes both functional
- [ ] Ready for full testing

**If all checked:** You're ready for [TESTING_CHECKLIST.md](TESTING_CHECKLIST.md)! 🎉

---

**That's it! You're up and running! 🚀**

Next: Follow [TESTING_CHECKLIST.md](TESTING_CHECKLIST.md) for comprehensive testing.
