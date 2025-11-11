import 'package:shared_preferences/shared_preferences.dart';

class SharedPrefsService {
  static const String _tokenKey = 'auth_token';
  static const String _userIdKey = 'user_id';
  static const String _roleKey = 'user_role';

  static Future<String?> getString(String key) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(key);
  }

  static Future<void> setString(String key, String value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(key, value);
  }

  static Future<void> saveAuthToken(String token) async {
    await setString(_tokenKey, token);
  }

  static Future<String?> getAuthToken() async {
    return getString(_tokenKey);
  }

  static Future<void> saveUserId(String userId) async {
    await setString(_userIdKey, userId);
  }

  static Future<String?> getUserId() async {
    return getString(_userIdKey);
  }

  static Future<void> saveUserRole(String role) async {
    await setString(_roleKey, role);
  }

  static Future<String?> getUserRole() async {
    return getString(_roleKey);
  }

  static Future<void> clearAll() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }
}