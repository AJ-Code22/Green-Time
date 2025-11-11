# GreenTime Kids - Testing Checklist

## Initial Setup ✓

- [ ] Clone/open project in VS Code
- [ ] Run `flutter clean`
- [ ] Run `flutter pub get` - should complete successfully
- [ ] Verify no syntax errors in IDE
- [ ] Check Firebase project is set up
- [ ] Verify `firebase_options.dart` has correct credentials

---

## Platform Testing

### Windows Desktop Testing

#### Launch App
```
Command: flutter run -d windows
Expected: App opens, shows login screen, no errors
```
- [ ] App launches without crashing
- [ ] No console errors
- [ ] Login screen displays correctly
- [ ] All text is readable
- [ ] UI is responsive to window resize

#### Test Login Flow
- [ ] Signup new parent account (parent@example.com)
- [ ] Success message displays
- [ ] User redirected to role selection
- [ ] Parent role can be selected
- [ ] Redirected to parent dashboard
- [ ] Parent dashboard loads with correct layout

#### Test Child Account
- [ ] Signup new child account (child@example.com)
- [ ] Select child role
- [ ] Redirected to child dashboard
- [ ] Child dashboard displays correctly
- [ ] No error messages

#### Verify Theme System
- [ ] Light mode loads by default (or last used mode)
- [ ] Colors match design spec:
  - [ ] Primary: #5ADCDE
  - [ ] Background: #EAFCFC (light) / #0D3A32 (dark)
- [ ] Theme toggle button visible in AppBar
- [ ] Can switch to dark mode
- [ ] All colors adjust correctly
- [ ] Text contrast is readable
- [ ] Theme persists after app restart

---

### Android Testing

#### Launch on Emulator
```
Commands: 
  flutter devices (to find emulator)
  flutter run -d <emulator-id>
```
- [ ] App installs without errors
- [ ] App launches on Android
- [ ] Layout is optimized for mobile (single column)
- [ ] Buttons are properly sized for touch
- [ ] Text is readable without zoom
- [ ] No layout overflow

#### Test Responsive Layout (Mobile)
- [ ] Dashboard cards stack vertically
- [ ] Images scale to screen width
- [ ] Form inputs are properly sized
- [ ] Scrolling works smoothly
- [ ] No horizontal scroll needed
- [ ] Bottom navigation/action buttons accessible

#### Test Image Upload (Mobile)
- [ ] Click "Complete Task" button
- [ ] Image picker opens
- [ ] Can select from gallery or take photo
- [ ] Selected image displays as preview
- [ ] Upload completes without errors
- [ ] Task status updates to "pending approval"

---

### Web Testing

#### Launch in Chrome
```
Command: flutter run -d chrome
```
- [ ] App loads in browser
- [ ] No console errors
- [ ] Responsive to browser window resize
- [ ] Desktop layout active (3 columns where applicable)
- [ ] Touch interactions work with mouse
- [ ] Keyboard navigation works

#### Test WebView (Redeem Page)
- [ ] Login as parent
- [ ] Navigate to Redeem page
- [ ] WebView loads ecomart.zone.id/landing
- [ ] Can scroll within WebView
- [ ] Back/reload buttons work
- [ ] Navigation within WebView functional

#### Test Child Access Control
- [ ] Login as child
- [ ] Try to navigate to Redeem page
- [ ] See "Access Restricted" message
- [ ] Cannot access store
- [ ] Message explains parent-only restriction

---

## Feature Testing

### Authentication Flow

#### Parent Signup
- [ ] Navigate to signup
- [ ] Enter email: parent@test.com
- [ ] Enter password: Test123!
- [ ] Confirm password
- [ ] Click "Sign Up"
- [ ] Success message appears
- [ ] Redirected to role selection
- [ ] Can select "Parent"
- [ ] Profile created in Firestore ✓

#### Child Signup
- [ ] Enter email: child@test.com
- [ ] Enter password: Test123!
- [ ] Click "Sign Up"
- [ ] Select "Child" role
- [ ] Redirected to child dashboard
- [ ] Child profile visible

#### Login
- [ ] Logout from one account
- [ ] Login with parent email/password
- [ ] Correctly redirected to parent dashboard
- [ ] All parent data loads

#### Logout
- [ ] Click logout button
- [ ] Confirm logout prompt
- [ ] Redirected to login screen
- [ ] Previous session cleared

---

### Parent Dashboard

#### Add Task
- [ ] Click "Add New Task" button
- [ ] Form displays with fields:
  - [ ] Task Title (required)
  - [ ] Description (required)
  - [ ] EcoPoints value (required)
- [ ] Fill all fields:
  - Title: "Plant a Tree"
  - Description: "Plant one tree in your area"
  - Points: 50
- [ ] Click "Create Task"
- [ ] Task appears in list immediately
- [ ] Form clears
- [ ] Task saved to Firestore (check Console)
- [ ] No duplicate tasks created

#### View Tasks
- [ ] All created tasks display in list
- [ ] Task count updates
- [ ] Can scroll through task list (if many tasks)
- [ ] Each task shows:
  - [ ] Title
  - [ ] Description
  - [ ] Points value
  - [ ] Status (pending/approved)

#### Task Approval Flow
- [ ] Open child dashboard
- [ ] Child completes task with image
- [ ] Switch to parent dashboard
- [ ] Pending approval task appears
- [ ] Image is visible in task details
- [ ] Can approve or reject
- [ ] Click "Approve"
- [ ] Task status changes to "approved"
- [ ] Child points update (+50)
- [ ] Switch to child dashboard
- [ ] Updated points visible

#### Device Lock
- [ ] Click "Lock Device" button
- [ ] Toggle shows locked status
- [ ] Firestore updated immediately (< 1 second)
- [ ] Open child app on different device
- [ ] Full-screen lock overlay appears
- [ ] Message: "Device Locked"
- [ ] Child cannot interact with app
- [ ] Parent unlocks device
- [ ] Lock overlay disappears < 1 second
- [ ] Child can use app again

#### Responsive Layout (Desktop)
- [ ] Dashboard uses 3-column grid
- [ ] Content has max-width of 1200px
- [ ] Content centered horizontally
- [ ] Proper spacing on large screens
- [ ] Not stretched to full width

#### Responsive Layout (Tablet)
- [ ] Dashboard uses 2-column grid
- [ ] Better space utilization than mobile
- [ ] Proper padding on sides
- [ ] All elements visible without scroll

#### Responsive Layout (Mobile)
- [ ] Dashboard uses single column
- [ ] Cards stack vertically
- [ ] No horizontal scroll
- [ ] Touch-friendly sizing
- [ ] Readable without zoom

---

### Child Dashboard

#### View Assigned Tasks
- [ ] Login as child
- [ ] See all parent-assigned tasks
- [ ] Task details visible:
  - [ ] Title
  - [ ] Description
  - [ ] Points offered
  - [ ] Status
- [ ] Can scroll through tasks
- [ ] Task count displays
- [ ] No ability to add tasks (correct, parent-only)

#### Complete Task
- [ ] Click "Complete Task" button
- [ ] Image picker opens
- [ ] Can select from gallery
- [ ] Can take camera photo (if permissions granted)
- [ ] Selected image displays as preview
- [ ] Click "Submit"
- [ ] Task status changes to "pending approval"
- [ ] Cannot modify once submitted
- [ ] Firestore task updated

#### Points & Stats Display
- [ ] Total EcoPoints displayed in header
- [ ] Environmental impact stats visible:
  - [ ] Water saved (liters)
  - [ ] CO2 reduced (kg)
  - [ ] Green time (minutes)
- [ ] Stats update when task is approved
- [ ] Real-time sync from Firestore

#### Device Lock Detection
- [ ] Parent locks device
- [ ] Full-screen overlay appears in child app
- [ ] Shows lock icon
- [ ] Shows "Device Locked" message
- [ ] Shows helpful message from parent
- [ ] Child cannot bypass lock
- [ ] Overlay disappears immediately when unlocked
- [ ] Uses StreamBuilder (real-time)

#### Responsive Layout
- [ ] Single column layout on mobile
- [ ] Cards stack vertically
- [ ] Touch-friendly buttons
- [ ] No horizontal scroll
- [ ] Readable text sizes
- [ ] 2-column on tablet
- [ ] 3-column on desktop

---

### Redeem Screen (WebView)

#### Parent Access
- [ ] Login as parent
- [ ] Navigate to Redeem page
- [ ] WebView loads successfully
- [ ] URL is ecomart.zone.id/landing
- [ ] Can see store products
- [ ] Can scroll within WebView
- [ ] Loading indicator shows during load
- [ ] Back button navigates back within WebView
- [ ] Reload button refreshes page
- [ ] Current points displayed in header

#### Child Access Denied
- [ ] Login as child
- [ ] Navigate to Redeem page
- [ ] See "Access Restricted" message
- [ ] Cannot access store
- [ ] Helpful message displayed
- [ ] Option to return to dashboard
- [ ] No ability to bypass restriction

#### WebView Functionality
- [ ] Links work within WebView
- [ ] Forms are interactive
- [ ] Scrolling is smooth
- [ ] Back/forward navigation works
- [ ] Page reload works
- [ ] No external browser opens (stays in app)
- [ ] Error handling if URL unreachable

---

### Theme System

#### Light Theme
- [ ] Default on fresh install (or respects preference)
- [ ] Colors correct:
  - [ ] Primary: #5ADCDE (cyan)
  - [ ] Background: #EAFCFC (off-white)
  - [ ] Surface: #CDF8F7
- [ ] AppBar visible with buttons
- [ ] Cards have shadow
- [ ] Text is black/dark (good contrast)
- [ ] All buttons styled correctly
- [ ] Input fields visible

#### Dark Theme
- [ ] Can toggle to dark mode
- [ ] Colors correct:
  - [ ] Primary: #5ADCDE (still cyan)
  - [ ] Background: #0D3A32 (deep dark)
  - [ ] Surface: #1A2F2A (dark green)
- [ ] Text is white (good contrast)
- [ ] Buttons styled for dark theme
- [ ] Cards visible with proper shadows
- [ ] Eye-friendly in low light

#### Theme Toggle
- [ ] Toggle button visible in AppBar
- [ ] Icon changes (sun/moon)
- [ ] Clicking toggles themes
- [ ] Smooth transition (no flashing)
- [ ] All screens update theme
- [ ] Preference persists after restart
- [ ] No broken components in either theme

#### Material 3 Components
- [ ] AppBar styled correctly
- [ ] Buttons (filled, outlined, text) - all styled
- [ ] Cards with elevation and shadows
- [ ] Text fields with proper borders
- [ ] Checkboxes and toggles
- [ ] Dialogs and bottom sheets
- [ ] Snackbars
- [ ] Navigation consistent

---

### Real-Time Synchronization

#### Parent-Child Task Sync
- [ ] Open parent dashboard on Device A
- [ ] Open child dashboard on Device B
- [ ] Parent creates task
- [ ] Child sees task < 2 seconds
- [ ] No manual refresh needed
- [ ] Real-time listener active

#### Points Update Sync
- [ ] Child completes task on Device B
- [ ] Parent sees submission on Device A < 1 second
- [ ] Parent approves task
- [ ] Child's points update < 1 second
- [ ] Both devices show same point total
- [ ] Firestore data matches

#### Device Lock Real-Time
- [ ] Parent locks on Device A
- [ ] Lock overlay appears on Device B < 500ms
- [ ] Parent unlocks
- [ ] Overlay disappears < 500ms
- [ ] No polling (actual real-time)

#### Status Updates
- [ ] Task status changes visible in real-time
- [ ] Approval status updates immediately
- [ ] No refresh needed
- [ ] Consistent across devices

---

### Firebase Integration

#### Firestore Verification
- [ ] Open Firebase Console
- [ ] Navigate to Firestore
- [ ] Collections visible:
  - [ ] users (with user documents)
  - [ ] tasks (with task documents)
  - [ ] device_locks (with lock status)
- [ ] User data correct
- [ ] Task data complete
- [ ] Timestamps recorded

#### Firebase Storage
- [ ] Complete task with image as child
- [ ] Go to Firebase Console → Storage
- [ ] Image uploaded to: tasks/{taskId}/proofs/
- [ ] Filename includes timestamp
- [ ] Image accessible via download URL
- [ ] Proper permissions set

#### Security Rules
- [ ] Child cannot access other child's data
- [ ] Child cannot modify parent data
- [ ] Parent can only access own family's data
- [ ] Unauthorized access blocked (check rules)

---

### Performance

#### Startup Time
- [ ] App launches < 3 seconds
- [ ] Dashboard loads < 2 seconds
- [ ] No freezing during load

#### Responsiveness
- [ ] Button clicks register instantly
- [ ] Form submission responsive
- [ ] Page transitions smooth
- [ ] No jank or frame drops
- [ ] Scrolling smooth

#### Memory Usage
- [ ] App doesn't crash on long use
- [ ] No memory leaks (monitor flutter logs)
- [ ] Smooth operation over 30 min+ use

#### Battery/CPU
- [ ] App doesn't drain battery rapidly
- [ ] CPU usage reasonable
- [ ] No excessive wake-ups
- [ ] Smooth with mobile devices

---

### Edge Cases & Error Handling

#### Network Disconnection
- [ ] Complete task offline
- [ ] See cached data
- [ ] Show "offline" indicator
- [ ] Sync when reconnected
- [ ] No data loss
- [ ] No app crash

#### Invalid Input
- [ ] Leave email blank → Error message
- [ ] Invalid email format → Error message
- [ ] Password too short → Error message
- [ ] Fields properly validated
- [ ] Helpful error messages

#### Firebase Errors
- [ ] Network timeout → Retry option
- [ ] Permission denied → Clear error message
- [ ] Missing data → Graceful fallback
- [ ] App doesn't crash

#### Large Data Sets
- [ ] App with 100+ tasks → Still responsive
- [ ] Large image upload → Progress indicator
- [ ] Proper pagination/loading
- [ ] No freezing

---

### Accessibility

#### Visual
- [ ] All text readable (good contrast)
- [ ] Buttons large enough to tap
- [ ] Colors not only indicator
- [ ] Dark mode available

#### Navigation
- [ ] Keyboard navigation works (web)
- [ ] Tab order logical
- [ ] Focus indicators visible
- [ ] Screen readers work (if supported)

#### Text
- [ ] Font sizes readable
- [ ] No tiny text
- [ ] Proper line spacing
- [ ] Language clear and simple

---

## Sign-Off

### Testing Completed
- [ ] Windows tested
- [ ] Android tested
- [ ] Web tested (Chrome)
- [ ] All features working
- [ ] No critical bugs
- [ ] Theme system working
- [ ] Real-time sync verified
- [ ] Image upload verified
- [ ] Device lock working
- [ ] WebView functional
- [ ] Responsive layouts verified
- [ ] Firebase integration confirmed

### Issues Found
None found (if all above checked) / Document below:

```
Issue 1: ___________________________________________________________
Solution: __________________________________________________________

Issue 2: ___________________________________________________________
Solution: __________________________________________________________

Issue 3: ___________________________________________________________
Solution: __________________________________________________________
```

### Overall Status
- [ ] **READY FOR PRODUCTION** - All tests passed
- [ ] **NEEDS FIXES** - See issues above
- [ ] **INCOMPLETE** - Still testing

### Sign-Off
- Tested By: _________________________
- Date: _________________________
- Platform: _________________________ 
- Notes: _________________________________________________________

---

## Next Steps After Testing

If ALL tests pass:
1. ✅ Deploy to Firebase Hosting (Web)
2. ✅ Submit to Google Play (Android)
3. ✅ Submit to App Store (iOS)
4. ✅ Create installers (Windows)

If issues found:
1. Document in "Issues Found" section
2. Fix issues
3. Re-test
4. Update this checklist

---

**Keep this checklist as your testing Bible!**

Good luck! 🚀

---

Last Updated: November 11, 2025
Created For: GreenTime Kids App
Purpose: Comprehensive Testing Verification
