# GreenTime Kids - Testing & Deployment Guide

## Quick Start Testing

### Prerequisites
- Flutter SDK installed and updated
- Android Emulator/Device or iOS Simulator
- Firebase project set up with proper credentials
- All dependencies installed (`flutter pub get`)

## Testing Checklist

### 1. Basic Build & Run ✅

#### Windows
```bash
cd c:\Users\ajays\Downloads\hi
flutter clean
flutter pub get
flutter run -d windows
```

**Expected Results:**
- App launches without errors
- Home screen shows correctly
- Light/Dark theme works
- Theme toggle button visible in app bar

#### Android
```bash
flutter run -d emulator-5554
# or for connected device
flutter run -d <device-id>
```

#### Web
```bash
flutter run -d chrome
```

---

### 2. Authentication Flow

#### Parent Login/Signup
1. Launch app
2. Navigate to Auth Screen
3. Sign up: Email: `parent@example.com` | Password: `password123`
4. Select "Parent" role
5. Verify redirected to Parent Dashboard

**Checklist:**
- [ ] Form validation works (email format, password length)
- [ ] Error messages displayed for invalid input
- [ ] Success message on signup
- [ ] User created in Firebase Firestore
- [ ] SharedPreferences stores user role and ID

#### Child Login/Signup
1. Sign up: Email: `child@example.com` | Password: `password123`
2. Select "Child" role
3. Verify redirected to Child Dashboard

**Checklist:**
- [ ] Different role redirects to correct dashboard
- [ ] Child's profile initialized in Firestore
- [ ] Profile displays correct role

---

### 3. Parent Dashboard Testing

#### Adding Tasks
1. Click "Add New Task" button
2. Fill in:
   - Task Title: "Plant a Tree"
   - Description: "Plant one tree in your area"
   - Points: 50
3. Click "Create Task"

**Checklist:**
- [ ] Task appears in task list
- [ ] Task saved to Firestore (check console)
- [ ] Form clears after submission
- [ ] Responsive layout on different screen sizes:
  - [ ] Mobile (< 600px): Single column layout
  - [ ] Tablet (600-1200px): 2-column grid
  - [ ] Desktop (> 1200px): 3-column grid with max-width 1200px

#### Task Management
1. View all tasks in list
2. Click task to view details
3. Review child submissions:
   - Check uploaded image
   - View completion timestamp

**Checklist:**
- [ ] All parent-created tasks display correctly
- [ ] Task counts update in real-time
- [ ] Approval/rejection buttons functional
- [ ] Points are deducted/added correctly

#### Device Lock Control
1. Click "Device Lock" button
2. Toggle to lock child's device
3. Open app on child's device
4. Verify lock overlay appears

**Checklist:**
- [ ] Lock status changes immediately (real-time)
- [ ] Firestore device_locks collection updated
- [ ] Child device shows lock overlay with message
- [ ] Lock can be toggled multiple times
- [ ] Unlock removes overlay from child device

#### Theme Toggle
1. Click theme toggle button (sun/moon icon)
2. Verify:
   - Background color changes to dark/light
   - Text color adjusts for readability
   - All components styled correctly

**Checklist:**
- [ ] Colors match design spec:
  - Light: #EAFCFC background, #5ADCDE primary
  - Dark: #0D3A32 background, #5ADCDE primary
- [ ] Preference persists after restart
- [ ] Smooth transition between themes

---

### 4. Child Dashboard Testing

#### Viewing Tasks
1. Login as child
2. Child Dashboard displays parent-created tasks

**Checklist:**
- [ ] All assigned tasks visible
- [ ] Task details (title, points, description) accurate
- [ ] No ability to add tasks (parent-only feature)
- [ ] Task completion button visible

#### Completing Task with Image Upload
1. Click "Complete Task" button
2. Choose "Camera" or "Gallery" to upload image
3. Select/take a photo
4. Submit completion

**Checklist:**
- [ ] Image picker opens correctly
- [ ] Selected image displays as preview
- [ ] Image uploads to Firebase Storage
- [ ] Firestore task marked as "completed"
- [ ] Timestamp recorded
- [ ] Parent can see image in approval queue

#### EcoPoints Display
1. Verify points displayed in app bar or profile section
2. Complete a task and have parent approve
3. Verify points increase immediately

**Checklist:**
- [ ] Real-time points sync from Firestore
- [ ] Environmental impact stats update:
  - [ ] Water saved (liters)
  - [ ] CO2 reduced (kg)
  - [ ] Green time (minutes)

#### Device Lock Response
1. Have parent lock device from parent dashboard
2. Child app should show full-screen lock overlay

**Checklist:**
- [ ] Overlay appears immediately
- [ ] Displays lock icon and messaging
- [ ] Child cannot interact with app behind overlay
- [ ] Overlay disappears when parent unlocks
- [ ] Uses StreamBuilder for real-time updates

---

### 5. Redeem Screen Testing

#### Parent Access
1. Login as parent
2. Navigate to "Redeem" page
3. Verify WebView loads ecomart.zone.id/landing

**Checklist:**
- [ ] WebView renders correctly
- [ ] Website loads (or shows proper loading state if offline)
- [ ] Navigation works (forward/back buttons)
- [ ] Reload button functions
- [ ] Loading spinner appears during load
- [ ] Error handling shows graceful message if URL fails

#### Parent-Only Access Control
1. Login as child
2. Try to navigate to Redeem page
3. Should see "Access Restricted" message

**Checklist:**
- [ ] Child blocked from redeem page
- [ ] Helpful message displayed
- [ ] Parent role check enforced
- [ ] Redirect back to child dashboard available

#### Points Display
1. Parent with 500+ points views Redeem page
2. Verify points display in header/action bar

**Checklist:**
- [ ] Current points visible
- [ ] Updates when child completes/parent approves tasks
- [ ] Responsive display on all screen sizes

---

### 6. Responsive Design Testing

#### Mobile (< 600px)
1. Run on small device/emulator
2. Test all screens:
   - [ ] Login/Signup form fits without horizontal scroll
   - [ ] Dashboard cards stack vertically
   - [ ] Buttons sized appropriately for touch
   - [ ] Text readable without zoom
   - [ ] Images scale properly

#### Tablet (600-1200px)
1. Run on tablet-sized device or use responsive testing
2. Verify:
   - [ ] Two-column layouts active
   - [ ] Better use of horizontal space
   - [ ] Touch targets appropriate

#### Desktop (> 1200px)
1. Run on Windows/Web with large window
2. Check:
   - [ ] Three-column layouts (dashboards)
   - [ ] Max-width 1200px applied
   - [ ] Horizontal centering of content
   - [ ] No excessive whitespace

**Verification:**
Use Flutter's responsive layout utilities:
```dart
ResponsiveHelper.isMobile(context)      // < 600px
ResponsiveHelper.isTablet(context)      // 600-1200px
ResponsiveHelper.isDesktop(context)     // > 1200px
```

---

### 7. Real-Time Synchronization Testing

#### Parent-Child Sync
**Setup:**
- Open parent dashboard on Device 1
- Open child dashboard on Device 2
- Same Firebase project/account

**Tests:**
1. Parent adds task → Child sees it within 2 seconds
2. Child uploads image → Parent sees it immediately
3. Parent approves → Child's points update instantly
4. Parent locks device → Child sees overlay < 1 second

**Checklist:**
- [ ] All changes sync in real-time
- [ ] No manual refresh needed
- [ ] Firestore listeners active
- [ ] StreamBuilders properly set up

---

### 8. Firebase Integration Testing

#### Firestore Collections Verification
1. Open Firebase Console
2. Navigate to Firestore Database
3. Verify collections exist:
   - [ ] `users` - user profiles and points
   - [ ] `tasks` - task definitions and submissions
   - [ ] `device_locks` - current lock status
   - [ ] `purchases` - redeemed items (for future)

#### Firebase Storage Testing
1. Complete a task with image as child
2. Go to Firebase Console → Storage
3. Verify image uploaded to correct path:
   ```
   tasks/{taskId}/proofs/{userId}_{timestamp}.jpg
   ```

**Checklist:**
- [ ] Images upload successfully
- [ ] File naming includes metadata
- [ ] Access controlled by security rules
- [ ] Proper error handling if upload fails

---

### 9. Theme System Testing

#### Theme Data Verification
All components should follow Material 3 design:

**Light Theme Colors:**
```
Primary: #5ADCDE
Secondary: #82E5E8
Tertiary: #AAEFF0
Background: #EAFCFC
Surface: #CDF8F7
```

**Dark Theme Colors:**
```
Primary: #5ADCDE
Secondary: #224942
Tertiary: #245B47
Background: #0D3A32
Surface: #1A2F2A
```

**Components to Verify:**
- [ ] AppBar styled correctly
- [ ] Buttons (filled, outlined, text)
- [ ] Cards with proper shadows
- [ ] Text fields with proper colors
- [ ] Checkboxes and toggles
- [ ] Dialog boxes
- [ ] Snackbars

#### Theme Persistence
1. Switch to dark mode
2. Close and restart app
3. Verify app opens in dark mode

**Checklist:**
- [ ] Theme preference saved to SharedPreferences
- [ ] Loads on app startup
- [ ] Survives app restart

---

### 10. Error Handling & Edge Cases

#### Network Disconnection
1. Complete task with internet on
2. Disable network
3. Try to view points/tasks

**Expected:**
- [ ] Offline local data displays
- [ ] Graceful error messages
- [ ] Auto-sync when connection restored

#### Firebase Security Rules Testing
1. Try unauthorized access to other user's data
2. Verify Firestore rules prevent access

**Expected:**
- [ ] Child cannot see other child's tasks
- [ ] Child cannot modify parent data
- [ ] Parent cannot see other family's data

#### Image Upload Failures
1. Upload corrupted image
2. Oversized image (>50MB)
3. Network interruption during upload

**Expected:**
- [ ] Proper error message displayed
- [ ] User can retry
- [ ] App doesn't crash

---

## Deployment Checklist

### Pre-Release Testing
- [ ] App tested on Android device
- [ ] App tested on iOS device
- [ ] App tested on Windows
- [ ] App tested on Web
- [ ] All 8 major requirements working
- [ ] No console errors
- [ ] No performance issues
- [ ] Battery drain acceptable
- [ ] Offline functionality verified

### Firebase Security Rules
```javascript
// Example rules - MUST be customized
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    // Only authenticated users can access
    match /users/{userId} {
      allow read, write: if request.auth.uid == userId;
    }
    
    match /tasks/{taskId} {
      allow read: if isChildOrParent();
      allow write: if isParent();
    }
    
    match /device_locks/{childId} {
      allow read, write: if isParentOf(childId);
    }
  }
}
```

### Environment Configuration
- [ ] Firebase project ID set correctly
- [ ] API keys configured for all platforms
- [ ] Storage bucket configured
- [ ] Security rules deployed
- [ ] CORS configured for Web

### Android Build
```bash
flutter build appbundle
# Upload to Google Play Console
```

### iOS Build
```bash
flutter build ios
# Archive and upload to App Store
```

### Windows Deployment
```bash
flutter build windows --release
# Create installer using MSIX
```

---

## Performance Benchmarks

**Target Metrics:**
- App startup: < 3 seconds
- Dashboard load: < 2 seconds
- Image upload: < 5 seconds
- Real-time sync: < 1 second latency
- Theme switch: < 500ms

**Measurement:**
```dart
Stopwatch watch = Stopwatch()..start();
// ... operation ...
print('Time: ${watch.elapsedMilliseconds}ms');
```

---

## Known Issues & Workarounds

### WebView Issues on Windows
**Issue:** WebView may not load external URLs
**Workaround:** Use `webview_flutter` with proper configuration

### Image Picker Permissions
**Issue:** Permission denied on some devices
**Solution:** Ensure manifest includes media permissions

### Firestore Cold Starts
**Issue:** First query may be slow
**Solution:** Pre-fetch common queries on app startup

---

## Support & Debugging

### Enable Debug Logging
```dart
// In main.dart
FirebaseFirestore.instance.settings = const Settings(
  persistenceEnabled: true,
);
```

### Check Logs
```bash
flutter logs
```

### Firebase Emulator (Optional)
```bash
firebase emulators:start
# In code:
FirebaseFirestore.instance.useFirestoreEmulator('localhost', 8080);
```

---

## Contact & Issues

Report issues to: [GitHub Issues Link]

---

**Testing Completed**: [ ] Yes [ ] No  
**Date**: _______  
**Tester Name**: _______  
**Device/Platform**: _______  
**Notes**: ___________________________________________________________
