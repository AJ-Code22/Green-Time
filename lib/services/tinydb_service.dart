import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

/// TinyDB: Simple key-value storage using SharedPreferences (cross-platform)
class TinyDB {
  static Future<void> setString(String key, String value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(key, value);
  }

  static Future<String?> getString(String key) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(key);
  }

  static Future<void> setJson(String key, Map<String, dynamic> value) async {
    await setString(key, jsonEncode(value));
  }

  static Future<Map<String, dynamic>?> getJson(String key) async {
    final str = await getString(key);
    if (str == null) return null;
    return jsonDecode(str) as Map<String, dynamic>;
  }

  static Future<void> setStringList(String key, List<String> value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(key, value);
  }

  static Future<List<String>> getStringList(String key) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getStringList(key) ?? [];
  }

  static Future<void> remove(String key) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(key);
  }

  static Future<void> clear() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }
}
