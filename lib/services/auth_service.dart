import 'dart:io' show Platform;
import 'tinydb_service.dart';

class AuthService {
  
  static Future<String> signIn(String email, String password) async {
    // TinyDB: Check if user exists and password matches
    final usersJson = await TinyDB.getJson('users') ?? {};
    if (!usersJson.containsKey(email)) {
      throw Exception('User not found.');
    }
    final user = usersJson[email];
    if (user['password'] != password) {
      throw Exception('Incorrect password.');
    }
    await TinyDB.setString('current_user', email);
    await TinyDB.setString('current_role', user['role']);
    return email;
  }

  static Future<String> signUp(String email, String password, String username, String role) async {
    // TinyDB: Add user to local db
    final usersJson = await TinyDB.getJson('users') ?? {};
    if (usersJson.containsKey(email)) {
      throw Exception('User already exists.');
    }
    usersJson[email] = {
      'email': email,
      'password': password,
      'username': username,
      'role': role,
    };
    await TinyDB.setJson('users', usersJson);
    await TinyDB.setString('current_user', email);
    await TinyDB.setString('current_role', role);
    return email;
  }

  static Future<void> signOut() async {
    await TinyDB.remove('current_user');
    await TinyDB.remove('current_role');
  }

  static Future<bool> isSignedIn() async {
    final user = await TinyDB.getString('current_user');
    return user != null;
  }

  static Future<String?> getCurrentUserId() async {
    return await TinyDB.getString('current_user');
  }

  static Future<String?> getCurrentUserRole() async {
    return await TinyDB.getString('current_role');
  }

  static Future<void> linkWithGoogle() async {
    // Not supported in TinyDB/local mode
    throw Exception('Google Sign-In not supported in offline/local mode.');
  }
}