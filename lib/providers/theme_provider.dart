import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../utils/neon_themes.dart';

class ThemeProvider with ChangeNotifier {
  String _currentTheme = 'Teal';

  String get currentTheme => _currentTheme;

  ThemeData get themeData => NeonThemes.themes[_currentTheme]!;

  ThemeProvider() {
    _loadThemeFromPrefs();
  }

  Future<void> _loadThemeFromPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    final theme = prefs.getString('neonTheme') ?? 'Teal';
    if (NeonThemes.themes.containsKey(theme)) {
      _currentTheme = theme;
      notifyListeners();
    }
  }

  Future<void> setTheme(String themeName) async {
    if (NeonThemes.themes.containsKey(themeName)) {
      _currentTheme = themeName;
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('neonTheme', themeName);
      notifyListeners();
    }
  }

  void toggleTheme() {
    final allKeys = NeonThemes.themes.keys.toList();
    int currentIndex = allKeys.indexOf(_currentTheme);
    int nextIndex = (currentIndex + 1) % allKeys.length;
    setTheme(allKeys[nextIndex]);
  }
}
