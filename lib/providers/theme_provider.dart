import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../utils/neon_themes.dart';

class ThemeProvider with ChangeNotifier {
  String _currentThemeName = 'Teal';

  // Expose the current theme name (e.g., "Neon", "Dark")
  String get currentThemeName => _currentThemeName;

  // Expose the actual ThemeData
  ThemeData get currentTheme => NeonThemes.themes[_currentThemeName]!;

  ThemeProvider() {
    _loadThemeFromPrefs();
  }

  Future<void> _loadThemeFromPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    final saved = prefs.getString('neonTheme') ?? 'Teal';
    if (NeonThemes.themes.containsKey(saved)) {
      _currentThemeName = saved;
      notifyListeners();
    }
  }

  Future<void> setTheme(String themeName) async {
    if (NeonThemes.themes.containsKey(themeName)) {
      _currentThemeName = themeName;
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('neonTheme', themeName);
      notifyListeners();
    }
  }

  Future<void> toggleTheme() async {
    final keys = NeonThemes.themes.keys.toList();
    final index = keys.indexOf(_currentThemeName);
    final nextIndex = (index + 1) % keys.length;
    await setTheme(keys[nextIndex]);
  }
}
