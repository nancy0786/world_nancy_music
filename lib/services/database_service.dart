import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class DatabaseService {
  // 📂 Save Playlists for a user
  static Future<void> savePlaylists(String userEmail, List<Map<String, dynamic>> playlists) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('${userEmail}_playlists', jsonEncode(playlists));
  }

  // 📂 Get Playlists
  static Future<List<Map<String, dynamic>>> getPlaylists(String userEmail) async {
    final prefs = await SharedPreferences.getInstance();
    final data = prefs.getString('${userEmail}_playlists');
    if (data == null) return [];
    return List<Map<String, dynamic>>.from(jsonDecode(data));
  }

  // 📜 Save history
  static Future<void> saveHistory(String userEmail, List<Map<String, String>> history) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('${userEmail}_history', jsonEncode(history));
  }

  // 📜 Get history
  static Future<List<Map<String, String>>> getHistory(String userEmail) async {
    final prefs = await SharedPreferences.getInstance();
    final data = prefs.getString('${userEmail}_history');
    if (data == null) return [];
    return List<Map<String, String>>.from(jsonDecode(data));
  }

  // 🧹 Clear all data for a user
  static Future<void> clearUserData(String userEmail) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('${userEmail}_playlists');
    await prefs.remove('${userEmail}_history');
  }
}
