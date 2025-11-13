# Firebase Windows Configuration
# This file provides a minimal Firebase configuration for Windows
# Firebase initialization is handled in Dart code with platform checks

# Since Firebase C++ SDK is not available for Windows,
# we skip Firebase native compilation and rely on the Dart-only implementation

# Set flags to tell plugins to skip Windows build
set(FIREBASE_SKIP_WINDOWS TRUE)

# Empty target to satisfy dependency requirements
add_library(firebase_windows_stub INTERFACE)
