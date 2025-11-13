import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import 'tinydb_service.dart';

class ThemeProvider extends ChangeNotifier {
  bool _isDarkMode = false;

  bool get isDarkMode => _isDarkMode;

  ThemeData get currentTheme {
    return _isDarkMode ? AppTheme.getDarkTheme() : AppTheme.getLightTheme();
  }

  ThemeProvider() {
    _loadThemePreference();
  }

  Future<void> _loadThemePreference() async {
  final savedTheme = await TinyDB.getString('theme_mode');
    _isDarkMode = savedTheme == 'dark';
    notifyListeners();
  }

  Future<void> toggleTheme() async {
    _isDarkMode = !_isDarkMode;
  await TinyDB.setString('theme_mode', _isDarkMode ? 'dark' : 'light');
    notifyListeners();
  }

  Future<void> setDarkMode(bool isDark) async {
    _isDarkMode = isDark;
  await TinyDB.setString('theme_mode', isDark ? 'dark' : 'light');
    notifyListeners();
  }
}
