import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';

class YtDlpService {
  /// Helper: Runs yt-dlp command and returns output as List of Maps (JSON)
  static Future<List<Map<String, String>>> _runYtdlpSearch(List<String> args) async {
    try {
      final result = await Process.run('yt-dlp', args);
      if (result.exitCode != 0) {
        debugPrint("yt-dlp error: ${result.stderr}");
        return [];
      }

      final lines = LineSplitter.split(result.stdout).toList();

      final List<Map<String, String>> parsed = [];

      for (final line in lines) {
        final item = jsonDecode(line);
        if (item is Map &&
            item.containsKey('title') &&
            item.containsKey('id')) {
          parsed.add({
            'title': item['title'].toString(),
            'url': 'https://www.youtube.com/watch?v=${item['id']}',
            'thumbnail': item['thumbnail']?.toString() ?? '',
            'channel': item['uploader']?.toString() ?? '',
            'videoId': item['id'].toString(),
          });
        }
      }

      return parsed;
    } catch (e) {
      debugPrint("yt-dlp exec failed: $e");
      return [];
    }
  }

  /// 🔍 Search YouTube using yt-dlp
  static Future<List<Map<String, String>>> search(String query) async {
    return await _runYtdlpSearch([
      '--dump-json',
      'ytsearch10:$query',
    ]);
  }

  /// 📈 Trending music
  static Future<List<Map<String, String>>> fetchTrending() async {
    return await search("top hindi songs 2024");
  }

  /// 🧠 Mood-based playlists
  static Future<List<Map<String, String>>> getMoodBasedPlaylists(String mood) async {
    final keywords = [
      "$mood playlist",
      "$mood hindi songs",
      "$mood music mix",
    ];

    final List<Map<String, String>> allResults = [];

    for (final keyword in keywords) {
      final res = await search(keyword);
      allResults.addAll(res);
    }

    return allResults.take(12).toList();
  }

  /// 📂 Songs from a playlist link
  static Future<List<Map<String, String>>> getSongsFromPlaylist(String playlistUrl) async {
    try {
      final result = await Process.run('yt-dlp', [
        '--flat-playlist',
        '--dump-json',
        playlistUrl,
      ]);

      if (result.exitCode != 0) {
        debugPrint("yt-dlp playlist error: ${result.stderr}");
        return [];
      }

      final lines = LineSplitter.split(result.stdout).toList();
      final List<Map<String, String>> items = [];

      for (final line in lines) {
        final item = jsonDecode(line);
        if (item is Map && item.containsKey('title') && item.containsKey('id')) {
          items.add({
            'title': item['title'].toString(),
            'videoId': item['id'].toString(),
            'url': 'https://www.youtube.com/watch?v=${item['id']}',
            'thumbnail': 'https://img.youtube.com/vi/${item['id']}/hqdefault.jpg',
            'channel': item['uploader']?.toString() ?? '',
          });
        }
      }

      return items;
    } catch (e) {
      debugPrint("yt-dlp playlist parse error: $e");
      return [];
    }
  }
}
