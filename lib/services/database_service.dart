// lib/services/database_service.dart

import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class DatabaseService {
  static Future<void> savePlaylists(String userEmail, List<Map<String, dynamic>> playlists) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('${userEmail}_playlists', jsonEncode(playlists));
  }

  static Future<List<Map<String, dynamic>>> getPlaylists(String userEmail) async {
    final prefs = await SharedPreferences.getInstance();
    final data = prefs.getString('${userEmail}_playlists');
    if (data == null) return [];
    return List<Map<String, dynamic>>.from(jsonDecode(data));
  }

  static Future<void> saveHistory(String userEmail, List<Map<String, dynamic>> history) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('${userEmail}_history', jsonEncode(history));
  }

  static Future<List<Map<String, dynamic>>> getHistory(String userEmail) async {
    final prefs = await SharedPreferences.getInstance();
    final data = prefs.getString('${userEmail}_history');
    if (data == null) return [];
    return List<Map<String, dynamic>>.from(jsonDecode(data));
  }

  static Future<void> clearUserData(String userEmail) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('${userEmail}_playlists');
    await prefs.remove('${userEmail}_history');
  }
}
