import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';

class YtDlpService {
  /// Helper: Runs yt-dlp and returns parsed stdout
  static Future<List<Map<String, String>>> _runYtdlpJsonSearch(List<String> args) async {
    try {
      final result = await Process.run('yt-dlp', args);
      if (result.exitCode != 0) {
        debugPrint("❌ yt-dlp error: ${result.stderr}");
        return [];
      }

      // Support multiple JSON objects line-by-line
      final lines = result.stdout.toString().split('\n');
      return lines.where((line) => line.trim().isNotEmpty).map((line) {
        final jsonMap = jsonDecode(line);
        return {
          'title': jsonMap['title'] ?? '',
          'url': 'https://www.youtube.com/watch?v=${jsonMap['id'] ?? ''}',
          'thumbnail': jsonMap['thumbnail'] ?? '',
          'channel': jsonMap['uploader'] ?? '',
          'videoId': jsonMap['id'] ?? '',
        };
      }).toList();
    } catch (e) {
      debugPrint("❌ yt-dlp exec failed: $e");
      return [];
    }
  }

  /// 🔍 Search YouTube (via yt-dlp)
  static Future<List<Map<String, String>>> search(String query) async {
    return await _runYtdlpJsonSearch([
      '--dump-json',
      'ytsearch10:$query',
    ]);
  }

  /// 📈 Trending songs (India region)
  static Future<List<Map<String, String>>> fetchTrending() async {
    return await search("top trending Hindi songs 2024");
  }

  /// 😎 Mood-based playlist search
  static Future<List<Map<String, String>>> getMoodBasedPlaylists(String mood) async {
    final Set<Map<String, String>> results = {};

    final queries = [
      "$mood playlist",
      "$mood music mix",
      "$mood Hindi songs"
    ];

    for (final q in queries) {
      final res = await search(q);
      results.addAll(res);
    }

    return results.toList().take(15).toList();
  }

  /// 📂 Get songs from YouTube playlist URL
  static Future<List<Map<String, String>>> getSongsFromPlaylist(String playlistUrl) async {
    try {
      final result = await Process.run('yt-dlp', [
        '--flat-playlist',
        '--dump-json',
        playlistUrl,
      ]);

      if (result.exitCode != 0) {
        debugPrint("❌ Playlist fetch failed: ${result.stderr}");
        return [];
      }

      final lines = result.stdout.toString().split('\n');
      return lines.where((line) => line.trim().isNotEmpty).map((line) {
        final jsonMap = jsonDecode(line);
        return {
          'title': jsonMap['title'] ?? '',
          'url': 'https://www.youtube.com/watch?v=${jsonMap['id'] ?? ''}',
          'thumbnail': 'https://img.youtube.com/vi/${jsonMap['id']}/hqdefault.jpg',
          'channel': jsonMap['uploader'] ?? '',
          'videoId': jsonMap['id'] ?? '',
        };
      }).toList();
    } catch (e) {
      debugPrint("❌ Playlist parse failed: $e");
      return [];
    }
  }
}
