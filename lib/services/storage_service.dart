import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';

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

  // ✅ Favorite Songs
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

  // ✅ Last Played
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

  // ✅ Theme Mode
  static Future<void> saveThemeMode(String mode) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('themeMode', mode);
  }

  static Future<String> getThemeMode() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('themeMode') ?? 'neon';
  }

  // ✅ Background
  static Future<void> saveBackgroundCategory(String category) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('backgroundCategory', category);
  }

  static Future<String> getBackgroundCategory() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('backgroundCategory') ?? 'girls';
  }

  // ✅ History
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

  // ✅ Download Audio
  static Future<void> downloadAudio(String url, String title) async {
    final permission = await Permission.storage.request();
    if (!permission.isGranted) return;

    final directory = await getExternalStorageDirectory();
    final filePath = '${directory!.path}/$title.mp3';

    final response = await http.get(Uri.parse(url));
    final file = File(filePath);
    await file.writeAsBytes(response.bodyBytes);

    final prefs = await SharedPreferences.getInstance();
    final email = await getCurrentUser();
    if (email == null) return;
    final key = 'downloads_$email';
    final existing = prefs.getStringList(key) ?? [];
    existing.insert(0, json.encode({'title': title, 'path': filePath}));
    prefs.setStringList(key, existing.take(50).toList());
  }

  static Future<List<Map<String, String>>> getDownloadedSongs() async {
    final prefs = await SharedPreferences.getInstance();
    final email = await getCurrentUser();
    if (email == null) return [];
    final key = 'downloads_$email';
    final list = prefs.getStringList(key) ?? [];
    return list.map((e) => Map<String, String>.from(json.decode(e))).toList();
  }

  // ✅ Custom Playlist Support
  static Future<List<Map<String, dynamic>>> getPlaylists() async {
    final prefs = await SharedPreferences.getInstance();
    final email = await getCurrentUser();
    if (email == null) return [];
    final jsonData = prefs.getString('playlists_$email');
    if (jsonData == null) return [];
    return List<Map<String, dynamic>>.from(json.decode(jsonData));
  }

  static Future<void> savePlaylists(List<Map<String, dynamic>> playlists) async {
    final prefs = await SharedPreferences.getInstance();
    final email = await getCurrentUser();
    if (email == null) return;
    prefs.setString('playlists_$email', json.encode(playlists));
  }

  static Future<void> addSongToPlaylist(String playlistName, Map<String, String> song) async {
    final playlists = await getPlaylists();
    final index = playlists.indexWhere((p) => p['title'] == playlistName);

    if (index != -1) {
      final songs = List<Map<String, String>>.from(playlists[index]['songs'] ?? []);
      songs.add(song);
      playlists[index]['songs'] = songs;
      await savePlaylists(playlists);
    }
  }

  static Future<void> removeSongFromPlaylist(String playlistName, int songIndex) async {
    final playlists = await getPlaylists();
    final index = playlists.indexWhere((p) => p['title'] == playlistName);

    if (index != -1) {
      final songs = List<Map<String, String>>.from(playlists[index]['songs'] ?? []);
      if (songIndex >= 0 && songIndex < songs.length) {
        songs.removeAt(songIndex);
        playlists[index]['songs'] = songs;
        await savePlaylists(playlists);
      }
    }
  }
}
