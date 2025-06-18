import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class StorageService {
  // 🔐 Current logged-in user email (stored globally)
  static const _currentUserKey = 'current_user_email';

  static Future<void> loginUser(String email) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_currentUserKey, email);
  }

  static Future<void> logoutUser() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_currentUserKey);
    // Do NOT delete downloads (they're app-sandboxed and local-only)
  }

  static Future<String?> getCurrentUser() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_currentUserKey);
  }

  // 🔁 Favorites (User-specific)
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

  // 🎧 Last played (User-specific)
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

  // 🎨 Theme
  static Future<void> saveThemeMode(String mode) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('themeMode', mode);
  }

  static Future<String> getThemeMode() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('themeMode') ?? 'neon';
  }

  // 🌌 Background
  static Future<void> saveBackgroundCategory(String category) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('backgroundCategory', category);
  }

  static Future<String> getBackgroundCategory() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('backgroundCategory') ?? 'girls';
  }

  // 📜 History (User-specific)
  static Future<void> saveToHistory(Map<String, String> song) async {
    final prefs = await SharedPreferences.getInstance();
    final email = await getCurrentUser();
    if (email == null) return;

    final key = 'song_history_$email';
    final historyJson = prefs.getStringList(key) ?? [];
    historyJson.insert(0, json.encode(song));
    await prefs.setStringList(key, historyJson.take(20).toList());
  }

  static Future<List<Map<String, String>>> getHistory() async {
    final prefs = await SharedPreferences.getInstance();
    final email = await getCurrentUser();
    if (email == null) return [];
    final historyJson = prefs.getStringList('song_history_$email') ?? [];
    return historyJson.map((e) => Map<String, String>.from(json.decode(e))).toList();
  }

  // 🧠 Dummy playlists
  static Future<List<Map<String, dynamic>>> getPlaylists() async {
    return [
      {
        "name": "🔥 Top 20 Weekly",
        "songs": [
          {
            "title": "Love Dose",
            "thumbnail": "https://img.youtube.com/vi/FYVvE4tr2BI/0.jpg",
          }
        ]
      },
      {
        "name": "❤️ Romantic",
        "songs": [
          {
            "title": "Tum Hi Ho",
            "thumbnail": "https://img.youtube.com/vi/Umqb9KENgmk/0.jpg",
          }
        ]
      }
    ];
  }
}
