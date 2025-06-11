import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class StorageService {
  static Future<void> saveFavoriteSongs(List<Map<String, String>> songs) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('favorites', jsonEncode(songs));
  }

  static Future<List<Map<String, String>>> getFavoriteSongs() async {
    final prefs = await SharedPreferences.getInstance();
    final data = prefs.getString('favorites');
    if (data == null) return [];
    return List<Map<String, String>>.from(jsonDecode(data));
  }

  static Future<void> saveLastPlayed(Map<String, String> song) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('lastPlayed', jsonEncode(song));
  }

  static Future<Map<String, String>?> getLastPlayed() async {
    final prefs = await SharedPreferences.getInstance();
    final data = prefs.getString('lastPlayed');
    if (data == null) return null;
    return Map<String, String>.from(jsonDecode(data));
  }

  static Future<void> saveThemeMode(String mode) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('themeMode', mode);
  }

  static Future<String> getThemeMode() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('themeMode') ?? 'neon';
  }

  static Future<void> saveBackgroundCategory(String category) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('backgroundCategory', category);
  }

  static Future<String> getBackgroundCategory() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('backgroundCategory') ?? 'girls';
  }
}
