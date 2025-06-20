import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'database_service.dart';

class StorageService {
  static const _currentUserKey = 'current_user_email';

  static Future<void> loginUser(String email) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_currentUserKey, email);
  }

  static Future<void> logoutUser() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_currentUserKey);
  }

  static Future<String?> getCurrentUser() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_currentUserKey);
  }

  // 🎵 FAVORITES
  static Future<void> saveFavoriteSongs(List<Map<String, String>> songs) async {
    final prefs = await SharedPreferences.getInstance();
    final email = await getCurrentUser();
    if (email == null) return;
    prefs.setString('favorites_$email', jsonEncode(songs));
  }

  static Future<List<Map<String, String>>> getFavoriteSongs() async {
    final prefs = await SharedPreferences.getInstance();
    final email = await getCurrentUser();
    if (email == null) return [];
    final data = prefs.getString('favorites_$email');
    if (data == null) return [];
    return List<Map<String, String>>.from(jsonDecode(data));
  }

  // ▶️ LAST PLAYED
  static Future<void> saveLastPlayed(Map<String, String> song) async {
    final prefs = await SharedPreferences.getInstance();
    final email = await getCurrentUser();
    if (email == null) return;
    prefs.setString('lastPlayed_$email', jsonEncode(song));
  }

  static Future<Map<String, String>?> getLastPlayed() async {
    final prefs = await SharedPreferences.getInstance();
    final email = await getCurrentUser();
    if (email == null) return null;
    final data = prefs.getString('lastPlayed_$email');
    if (data == null) return null;
    return Map<String, String>.from(jsonDecode(data));
  }

  // 🌓 THEME
  static Future<void> saveThemeMode(String mode) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('themeMode', mode);
  }

  static Future<String> getThemeMode() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('themeMode') ?? 'neon';
  }

  // 🌄 BACKGROUND
  static Future<void> saveBackgroundCategory(String category) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('backgroundCategory', category);
  }

  static Future<String> getBackgroundCategory() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('backgroundCategory') ?? 'girls';
  }

  // 📜 HISTORY
  static Future<void> saveToHistory(Map<String, String> song) async {
    final email = await getCurrentUser();
    if (email == null) return;

    final currentHistory = await DatabaseService.getHistory(email);
    currentHistory.insert(0, song);
    await DatabaseService.saveHistory(email, currentHistory.take(20).toList());
  }

  static Future<List<Map<String, String>>> getHistory() async {
    final email = await getCurrentUser();
    if (email == null) return [];
    return await DatabaseService.getHistory(email);
  }

  // 📂 PLAYLISTS
  static Future<List<Map<String, dynamic>>> getPlaylists() async {
    final email = await getCurrentUser();
    if (email == null) return [];
    return await DatabaseService.getPlaylists(email);
  }

  static Future<void> savePlaylists(List<Map<String, dynamic>> playlists) async {
    final email = await getCurrentUser();
    if (email == null) return;
    await DatabaseService.savePlaylists(email, playlists);
  }
}
