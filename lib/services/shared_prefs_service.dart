import 'package:shared_preferences/shared_preferences.dart';

class SharedPrefsService {
  static late SharedPreferences _prefs;

  static const _kUsername = 'username';
  static const _kIsChild = 'is_child';
  static const _kDailyLimit = 'daily_limit_minutes';

  static Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  static String? get username => _prefs.getString(_kUsername);
  static bool get isChild => _prefs.getBool(_kIsChild) ?? true;
  static int get dailyLimit => _prefs.getInt(_kDailyLimit) ?? 60;

  static Future<void> setUsername(String username) async => await _prefs.setString(_kUsername, username);
  static Future<void> setIsChild(bool isChild) async => await _prefs.setBool(_kIsChild, isChild);
  static Future<void> setDailyLimit(int minutes) async => await _prefs.setInt(_kDailyLimit, minutes);
}
