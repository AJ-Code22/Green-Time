import 'package:cloud_firestore/cloud_firestore.dart';
import 'shared_prefs_service.dart';

class AuthService {
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  
  static Future<String> signIn(String email, String password) async {
    try {
      // First try local authentication
      final userData = await LocalDBService.verifyLogin(email, password);
      if (userData == null) {
        throw Exception('Invalid credentials');
      }

      // Store the auth state
      await SharedPrefsService.saveAuthToken('local_token');
      await SharedPrefsService.saveUserId(email);  // Using email as userId
      await SharedPrefsService.saveUserRole(userData['role']);

      // Sync with Firestore if possible
      try {
        final doc = await _firestore.collection('users').doc(email).get();
        if (!doc.exists) {
          await _firestore.collection('users').doc(email).set(userData);
        }
      } catch (e) {
        print('Error syncing with Firestore: $e');
      }
      
      return email;  // Return email as userId
    } catch (e) {
      throw Exception('Authentication failed: $e');
    }
  }

  static Future<String> signUp(String email, String password, String username, String role) async {
    try {
      // Create user data
      final userData = {
        'email': email,
        'username': username,
        'role': role,
        'ecoPoints': 0,
        'greenTime': 0,
        'waterSaved': 0.0,
        'co2Saved': 0.0,
        'streaks': 0,
        'createdAt': DateTime.now().toIso8601String(),
      };

      // Create user in local DB first
      final success = await LocalDBService.createUser(email, password, userData);
      if (!success) {
        throw Exception('User already exists');
      }

      // Create user in Firestore for cloud sync
      try {
        await _firestore.collection('users').doc(email).set({
          ...userData,
          'createdAt': FieldValue.serverTimestamp(),
        });
      } catch (e) {
        print('Error creating user in Firestore: $e');
      }

      // Store the auth state
      await SharedPrefsService.saveAuthToken('local_token');
      await SharedPrefsService.saveUserId(email);
      await SharedPrefsService.saveUserRole(role);
      
      return email;  // Return email as userId
    } catch (e) {
      throw Exception('Account creation failed: $e');
    }
  }

  static Future<void> signOut() async {
    await SharedPrefsService.clearAll();
  }

  static Future<bool> isSignedIn() async {
    final token = await SharedPrefsService.getAuthToken();
    return token != null;
  }

  static Future<String?> getCurrentUserId() async {
    return SharedPrefsService.getUserId();
  }

  static Future<String?> getCurrentUserRole() async {
    return SharedPrefsService.getUserRole();
  }
}