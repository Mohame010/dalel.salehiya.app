import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppThemeProvider with ChangeNotifier {
  static const _themeKey = "isDark";

  bool _isDark = false;

  bool get isDark => _isDark;

  ThemeMode get themeMode =>
      _isDark ? ThemeMode.dark : ThemeMode.light;

  /// 🟢 تحميل من storage
  Future<void> loadTheme() async {
    final prefs = await SharedPreferences.getInstance();
    _isDark = prefs.getBool(_themeKey) ?? false;
    notifyListeners();
  }

  /// 🌙 تغيير الثيم
  Future<void> toggleTheme() async {
    _isDark = !_isDark;

    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_themeKey, _isDark);

    notifyListeners();
  }
}