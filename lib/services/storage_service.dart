import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class StorageService {
  // 🔁 Already present – unchanged
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

  // ✅ NEW: History support
  static Future<void> saveToHistory(Map<String, String> song) async {
    final prefs = await SharedPreferences.getInstance();
    final historyJson = prefs.getStringList('song_history') ?? [];
    historyJson.insert(0, json.encode(song));
    await prefs.setStringList('song_history', historyJson.take(20).toList());
  }

  static Future<List<Map<String, String>>> getHistory() async {
    final prefs = await SharedPreferences.getInstance();
    final historyJson = prefs.getStringList('song_history') ?? [];
    return historyJson.map((e) => Map<String, String>.from(json.decode(e))).toList();
  }

  // ✅ NEW: Dummy playlists (you can replace with real backend logic later)
  static Future<List<Map<String, dynamic>>> getPlaylists() async {
    return [
      {
        "title": "🔥 Top 20 Weekly",
        "songs": [
          {
            "title": "Love Dose",
            "thumbnail": "https://img.youtube.com/vi/FYVvE4tr2BI/0.jpg",
          }
        ]
      },
      {
        "title": "❤️ Romantic",
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
