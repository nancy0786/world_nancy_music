import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';

class YtDlpService {
  /// Helper: Runs yt-dlp command and returns output as JSON-decoded List or Map.
  static Future<dynamic> _runYtdlpCommand(List<String> args) async {
    try {
      final result = await Process.run('yt-dlp', args);
      if (result.exitCode != 0) {
        debugPrint("yt-dlp error: ${result.stderr}");
        return null;
      }

      return jsonDecode(result.stdout);
    } catch (e) {
      debugPrint("yt-dlp exec failed: $e");
      return null;
    }
  }

  /// 🔍 Search for videos/playlists
  static Future<List<Map<String, String>>> search(String query) async {
    final output = await _runYtdlpCommand([
      '--dump-json',
      'ytsearch10:$query',
    ]);

    if (output == null) return [];

    final List<Map<String, String>> results = [];

    // If output is a stream of JSON objects (each line), parse each
    if (output is List) {
      for (final item in output) {
        if (item is Map && item['title'] != null && item['url'] != null) {
          results.add({
            'title': item['title'],
            'url': 'https://www.youtube.com/watch?v=${item['id']}',
            'thumbnail': item['thumbnail'],
            'channel': item['uploader'] ?? '',
            'videoId': item['id'],
          });
        }
      }
    } else if (output is Map) {
      results.add({
        'title': output['title'],
        'url': 'https://www.youtube.com/watch?v=${output['id']}',
        'thumbnail': output['thumbnail'],
        'channel': output['uploader'] ?? '',
        'videoId': output['id'],
      });
    }

    return results;
  }

  /// 📈 Fetch trending music (India region)
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

    final Set<Map<String, String>> allResults = {};

    for (final keyword in keywords) {
      final results = await search(keyword);
      allResults.addAll(results);
    }

    return allResults.toList().take(12).toList();
  }

  /// 📂 Fetch songs from a playlist URL
  static Future<List<Map<String, String>>> getSongsFromPlaylist(String playlistUrl) async {
    final result = await _runYtdlpCommand([
      '--flat-playlist',
      '--dump-json',
      playlistUrl,
    ]);

    if (result == null) return [];

    final List<Map<String, String>> items = [];

    if (result is List) {
      for (var item in result) {
        if (item is Map && item.containsKey('title') && item.containsKey('id')) {
          items.add({
            'title': item['title'],
            'videoId': item['id'],
            'url': 'https://www.youtube.com/watch?v=${item['id']}',
            'thumbnail': 'https://img.youtube.com/vi/${item['id']}/hqdefault.jpg',
            'channel': item['uploader'] ?? '',
          });
        }
      }
    }

    return items;
  }
}
