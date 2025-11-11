import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:io';

class DeviceLockService {
  static FirebaseFirestore get _firestore {
    try {
      return FirebaseFirestore.instance;
    } catch (e) {
      print('Firestore not available: $e');
      rethrow;
    }
  }

  /// Check if a child's device is locked
  static Stream<bool> watchDeviceLock(String childUserId) {
    if (Platform.isWindows || Platform.isLinux || Platform.isMacOS) {
      // Return empty stream on desktop platforms
      return Stream.value(false);
    }
    
    return _firestore
        .collection('device_locks')
        .doc(childUserId)
        .snapshots()
        .map((doc) {
      if (!doc.exists) return false;
      return doc.data()?['isLocked'] ?? false;
    });
  }

  /// Lock a child's device
  static Future<void> lockDevice(String childUserId, String parentUserId) async {
    if (Platform.isWindows || Platform.isLinux || Platform.isMacOS) {
      print('Device lock not available on desktop platforms');
      return;
    }
    
    await _firestore.collection('device_locks').doc(childUserId).set({
      'childId': childUserId,
      'parentId': parentUserId,
      'isLocked': true,
      'lockedAt': FieldValue.serverTimestamp(),
    });
  }


  /// Unlock a child's device
  static Future<void> unlockDevice(String childUserId) async {
    if (Platform.isWindows || Platform.isLinux || Platform.isMacOS) {
      print('Device lock not available on desktop platforms');
      return;
    }
    
    await _firestore.collection('device_locks').doc(childUserId).set({
      'isLocked': false,
      'unlockedAt': FieldValue.serverTimestamp(),
    }, SetOptions(merge: true));
  }

  /// Get current lock status
  static Future<bool> getDeviceLockStatus(String childUserId) async {
    if (Platform.isWindows || Platform.isLinux || Platform.isMacOS) {
      return false; // Always unlocked on desktop
    }
    
    try {
      final doc = await _firestore.collection('device_locks').doc(childUserId).get();
      if (!doc.exists) return false;
      return doc.data()?['isLocked'] ?? false;
    } catch (e) {
      print('Error getting device lock status: $e');
      return false;
    }
  }
}
