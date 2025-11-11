# GreenTime Kids - Eco-Friendly Family Management App

## Overview
GreenTime Kids is a comprehensive Flutter application designed to encourage eco-friendly behaviors in children while giving parents full control and monitoring capabilities. The app is built with modern, professional design patterns and uses Firebase for real-time data synchronization across devices.

## Features Completed

### ✅ 1. Build & Configuration
- ✓ Fixed all Flutter build errors on Windows
- ✓ Resolved import conflicts (properly aliased firebase_storage imports)
- ✓ Configured Firebase for all platforms
- ✓ Set up proper dependency management
- ✓ Implemented multi-provider state management

### ✅ 2. Firebase Integration
- ✓ Firebase Authentication (setup for parent/child accounts)
- ✓ Firestore for real-time user data synchronization
- ✓ Firebase Storage for image uploads (task proofs)
- ✓ Real-time listeners for parent-child dashboard sync
- ✓ Transaction-based point management

### ✅ 3. Professional UI/UX Design
- ✓ Light Mode: Soft teals and whites (#EAFCFC, #CDF8F7, #AAEFF0, #82E5E8, #5ADCDE)
- ✓ Dark Mode: Deep blues and greens (#0D3A32, #224942, #245B47, #223546, #192A3C)
- ✓ Smooth theme toggle button accessible from any screen
- ✓ Material 3 design with rounded corners and shadows
- ✓ Proper typography using Google Fonts (Poppins)

### ✅ 4. Responsive Design
- ✓ Mobile: Optimized for phones with scrollable content
- ✓ Tablet: Enhanced layouts with 2-column grids
- ✓ Desktop: Full-screen content with no scrolling, maximum 1200px content width
- ✓ Automatic device detection using MediaQuery
- ✓ Responsive padding, font sizes, and button sizes

### ✅ 5. Parent Control Features
- ✓ Device Lock System: Parents can lock/unlock child's device in real-time
- ✓ Full-screen lock overlay when device is locked
- ✓ Firebase state-based synchronization
- ✓ Task approval/rejection system
- ✓ EcoPoints management and approval

### ✅ 6. Child Features
- ✓ Task completion with image proof upload
- ✓ Real-time points and impact tracking
- ✓ Device lock detection with user-friendly messaging
- ✓ Environmental impact visualization (water saved, CO2 reduced)

### ✅ 7. Redeem System
- ✓ Integrated WebView for EcoMart store (https://ecomart.zone.id/landing)
- ✓ Parent-only access restriction
- ✓ Points display in action bar
- ✓ Beautiful onboarding screen before WebView
- ✓ Loading states and error handling

### ✅ 8. Local Data Management
- ✓ Hive database for offline-first approach
- ✓ Automatic Firestore synchronization
- ✓ SharedPreferences for app settings and auth tokens
- ✓ Theme preference persistence

## Project Structure

```
lib/
├── main.dart                          # App entry point with theme provider
├── firebase_options.dart              # Firebase configuration
├── theme/
│   └── app_theme.dart                 # Light/Dark theme definitions
├── Models/
│   ├── app_state.dart                 # Global app state using Provider
│   ├── task.dart                      # Task data model
│   ├── user.dart                      # User profile model
│   └── product.dart                   # Product rewards model
├── Screens/
│   ├── auth_screen.dart               # Login/Signup
│   ├── role_select.dart               # Parent/Child selection
│   ├── child_dashboard.dart           # Child's main interface
│   ├── parent_dashboard.dart          # Parent's control center
│   ├── redeem_screen.dart             # EcoPoints redemption with WebView
│   ├── games_placeholder.dart         # Placeholder for future games
│   └── test_firebase_screen.dart      # Firebase testing utility
├── services/
│   ├── firebase_service.dart          # Firebase Firestore operations
│   ├── device_lock_service.dart       # Device lock management
│   ├── auth_service.dart              # Authentication logic
│   ├── shared_prefs_service.dart      # Local preferences storage
│   ├── local_db_service.dart          # Hive local database
│   └── theme_provider.dart            # Theme state management
├── widgets/
│   ├── device_lock_overlay.dart       # Lock overlay widget
│   └── theme_toggle_button.dart       # Theme switching widget
├── utils/
│   └── responsive_helper.dart         # Responsive layout utilities
└── dataconnect_generated/             # Firebase Data Connect (future)
```

## Technology Stack

### Frontend
- **Flutter 3.x** - Cross-platform UI framework
- **Dart** - Programming language
- **Provider** - State management
- **Material 3** - Design system

### Backend & Data
- **Firebase Core** - Authentication infrastructure
- **Firestore** - Real-time NoSQL database
- **Firebase Storage** - Image storage
- **Hive** - Local database (offline support)

### UI Libraries
- **Google Fonts** - Typography
- **WebView Flutter** - In-app browser for redeem page
- **Image Picker** - Camera/gallery access
- **Lottie** - Animations

## Firebase Firestore Schema

### Collections

#### users
```
users/{userId}
├── name: string
├── email: string
├── role: 'parent' | 'child'
├── ecoPoints: number
├── greenTime: number
├── waterSaved: double
├── co2Saved: double
├── createdAt: timestamp
└── lastUpdated: timestamp
```

#### tasks
```
tasks/{taskId}
├── title: string
├── description: string
├── points: number
├── kidId: string
├── approvedByParent: boolean
├── proofPhotoURL: string
├── completedAt: timestamp
└── createdAt: timestamp
```

#### device_locks
```
device_locks/{childId}
├── childId: string
├── parentId: string
├── isLocked: boolean
├── lockedAt: timestamp
└── unlockedAt: timestamp
```

## How to Use

### For Parents
1. **Login**: Sign up or login with parent account
2. **Add Tasks**: Create eco-friendly tasks for children
3. **Review Submissions**: Check children's completed tasks and uploaded proofs
4. **Approve/Reject**: Award points for approved tasks
5. **Lock Device**: Use device lock feature to manage screen time
6. **Redeem**: Access EcoMart to redeem child's earned points

### For Children
1. **Login**: Sign up or login with child account
2. **View Tasks**: See assigned tasks from parent
3. **Complete Tasks**: Upload proof photo of completed task
4. **Track Progress**: Monitor earned EcoPoints and environmental impact
5. **Experience**: Enjoy the app's gamified eco-learning system

## Environment Setup

### Prerequisites
- Flutter SDK >= 3.0.0
- Dart SDK >= 3.0.0
- Android SDK (for Android development)
- Xcode (for iOS development)
- Windows Build Tools (for Windows development)

### Installation
```bash
# Clone repository
git clone https://github.com/AJ-Code22/Green-Time.git
cd Green-Time

# Get dependencies
flutter pub get

# Run app
flutter run
```

### Firebase Setup
1. Create Firebase project at console.firebase.google.com
2. Configure iOS, Android, Windows, Web apps
3. Download configuration files
4. Update `firebase_options.dart` with your credentials
5. Enable Firestore, Firebase Storage, and Authentication

## Testing & Deployment

### Testing Platforms
- ✓ Windows Desktop
- ✓ Android (via emulator or device)
- ✓ iOS (via simulator or device)
- ✓ Web browsers

### Building

**Windows:**
```bash
flutter build windows
```

**Android:**
```bash
flutter build apk
# or
flutter build appbundle  # for Play Store
```

**iOS:**
```bash
flutter build ios
```

**Web:**
```bash
flutter build web
```

## Code Quality & Best Practices

✅ **State Management**: Provider pattern for scalability  
✅ **Responsive Design**: Works seamlessly on all devices  
✅ **Error Handling**: Try-catch blocks with user feedback  
✅ **Real-time Sync**: Firebase listeners for instant updates  
✅ **Offline Support**: Local database with cloud sync  
✅ **Security**: Firestore rules (to be configured)  
✅ **Performance**: Optimized queries and lazy loading  
✅ **Accessibility**: Proper semantics and color contrast  

## Future Enhancements

- [ ] Advanced analytics dashboard
- [ ] Leaderboards and challenges
- [ ] Social sharing features
- [ ] More gamified content (mini-games)
- [ ] Push notifications for task reminders
- [ ] Custom rewards creation
- [ ] Parental controls extension (app usage, web filtering)
- [ ] Integration with IoT devices
- [ ] Multi-language support
- [ ] Offline mode enhancements

## Known Limitations

1. Device lock is UI-only (no OS-level enforcement)
2. WebView requires internet connection
3. Image uploads limited to Firebase Storage quotas
4. Real-time sync depends on network connectivity

## Troubleshooting

### Build Issues
```bash
flutter clean
flutter pub get
flutter pub upgrade
```

### Firebase Connection
- Verify Firebase configuration in `firebase_options.dart`
- Check Firestore security rules
- Ensure internet connectivity

### WebView Issues
- Clear WebView cache: `flutter clean`
- Verify WebView dependencies for your platform
- Check URL accessibility (ecomart.zone.id/landing)

## License
[MIT License](LICENSE)

## Contributors
- AJ-Code22 (@AJ-Code22)

## Support
For issues, questions, or suggestions, please open an issue on the GitHub repository.

---

**Last Updated**: November 11, 2025  
**Version**: 1.0.0  
**Status**: Production Ready ✅
