import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class DownloadManager {
  /// Returns a list of downloaded songs (from local storage)
  static Future<List<Map<String, dynamic>>> getDownloadedSongs() async {
    final prefs = await SharedPreferences.getInstance();
    final List<String> stored = prefs.getStringList('downloadedSongs') ?? [];

    return stored.map((str) {
      try {
        return jsonDecode(str) as Map<String, dynamic>;
      } catch (_) {
        return {}; // fallback on decode error
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
