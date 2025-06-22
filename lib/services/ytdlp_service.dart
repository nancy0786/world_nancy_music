import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';

class YtDlpService {
  /// 🔧 Run yt-dlp command and return stdout lines
  static Future<List<Map<String, dynamic>>> _runAndParseLines(List<String> args) async {
    try {
      final process = await Process.start('yt-dlp', args, runInShell: true);
      final output = await process.stdout.transform(utf8.decoder).transform(const LineSplitter()).toList();
      final List<Map<String, dynamic>> results = [];

      for (var line in output) {
        final jsonLine = jsonDecode(line);
        results.add(jsonLine);
      }

      return results;
    } catch (e) {
      debugPrint("yt-dlp error: $e");
      return [];
    }
  }

  /// 🔍 Search YouTube
  static Future<List<Map<String, String>>> search(String query) async {
    final raw = await _runAndParseLines(['ytsearch10:$query', '--dump-json']);
    return raw.map((item) {
      final thumb = item['thumbnail'] ??
          (item['thumbnails'] != null && item['thumbnails'].isNotEmpty
              ? item['thumbnails'].last['url']
              : '');
      return {
        'title': item['title'] ?? '',
        'url': 'https://www.youtube.com/watch?v=${item['id']}',
        'thumbnail': thumb,
        'channel': item['uploader'] ?? '',
        'videoId': item['id'] ?? '',
      };
    }).toList();
  }

  /// 📈 Trending Music
  static Future<List<Map<String, String>>> fetchTrending() async {
    return await search("top trending hindi songs 2024");
  }

  /// 🎵 Mood Based Playlists
  static Future<List<Map<String, String>>> getMoodBasedPlaylists(String mood) async {
    final queries = ["$mood playlist", "$mood music mix", "$mood Hindi songs"];
    final Set<Map<String, String>> all = {};
    for (final q in queries) {
      final res = await search(q);
      all.addAll(res);
    }
    return all.take(12).toList();
  }

  /// 🎧 Get Songs from Playlist
  static Future<List<Map<String, String>>> getSongsFromPlaylist(String playlistUrl) async {
    final raw = await _runAndParseLines(['--flat-playlist', '--dump-json', playlistUrl]);
    return raw.map((item) {
      return {
        'title': item['title'] ?? '',
        'videoId': item['id'] ?? '',
        'url': 'https://www.youtube.com/watch?v=${item['id']}',
        'thumbnail': 'https://img.youtube.com/vi/${item['id']}/hqdefault.jpg',
        'channel': item['uploader'] ?? '',
      };
    }).toList();
  }

  /// ▶️ Audio Stream URL for Player
  static Future<Map<String, String>?> getAudioStream(String videoId) async {
    try {
      final urlProcess = await Process.run('yt-dlp', ['-f', 'bestaudio', '-g', 'https://www.youtube.com/watch?v=$videoId']);
      final streamUrl = urlProcess.stdout.toString().trim();

      final titleProcess = await Process.run('yt-dlp', ['--get-title', '--no-warnings', 'https://www.youtube.com/watch?v=$videoId']);
      final title = titleProcess.stdout.toString().trim();

      return {
        'title': title,
        'url': streamUrl,
      };
    } catch (e) {
      debugPrint("yt-dlp stream fetch error: $e");
      return null;
    }
  }
}
