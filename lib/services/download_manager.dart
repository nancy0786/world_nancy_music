import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class DownloadManager {
  /// Returns a list of downloaded songs (from local storage)
  static Future<List<Map<String, dynamic>>> getDownloadedSongs() async {
    final prefs = await SharedPreferences.getInstance();
    final List<String> stored = prefs.getStringList('downloadedSongs') ?? [];

    return stored.map((str) {
      try {
        final decoded = jsonDecode(str);
        if (decoded is Map) {
          // Ensure proper typing
          return Map<String, dynamic>.from(decoded);
        }
        return <String, dynamic>{};
      } catch (_) {
        return <String, dynamic>{}; // fallback on decode error
      }
    }).where((item) => item.isNotEmpty).toList();
  }

  /// Call this when saving new songs to local list
  static Future<void> saveDownloadedSong(Map<String, dynamic> song) async {
    final prefs = await SharedPreferences.getInstance();
    final List<String> stored = prefs.getStringList('downloadedSongs') ?? [];

    stored.add(jsonEncode(song));
    await prefs.setStringList('downloadedSongs', stored);
  }
}
