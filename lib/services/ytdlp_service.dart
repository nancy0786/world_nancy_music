import 'dart:convert';
import 'dart:io';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';

class YtDlpService {
  static Future<String> _getBinaryPath() async {
    final dir = await getApplicationSupportDirectory();
    final file = File('${dir.path}/yt-dlp');

    if (!await file.exists()) {
      final byteData = await rootBundle.load('assets/yt-dlp');
      await file.writeAsBytes(byteData.buffer.asUint8List(), flush: true);
      await Process.run('chmod', ['+x', file.path]);
    }

    return file.path;
  }

  static Future<List<Map<String, dynamic>>> search(String query) async {
    final ytDlp = await _getBinaryPath();
    final process = await Process.run(
      ytDlp,
      ['ytsearch10:$query', '--dump-json'],
    );

    final lines = LineSplitter.split(process.stdout.toString());
    return lines
        .map((line) => Map<String, dynamic>.from(jsonDecode(line)))
        .toList();
  }

  static Future<Map<String, dynamic>> getAudioStream(String videoId) async {
    final ytDlp = await _getBinaryPath();
    final url = 'https://www.youtube.com/watch?v=$videoId';
    final result = await Process.run(
      ytDlp,
      [url, '-f', 'bestaudio', '--dump-json'],
    );
    return Map<String, dynamic>.from(jsonDecode(result.stdout.toString()));
  }

  static Future<List<Map<String, dynamic>>> getSongsFromPlaylist(String playlistId) async {
    final ytDlp = await _getBinaryPath();
    final url = 'https://www.youtube.com/playlist?list=$playlistId';
    final result = await Process.run(
      ytDlp,
      [url, '--flat-playlist', '--dump-json'],
    );

    final lines = LineSplitter.split(result.stdout.toString());
    return lines
        .map((line) => Map<String, dynamic>.from(jsonDecode(line)))
        .toList();
  }

  static Future<List<Map<String, dynamic>>> fetchTrending() async {
    return await search("Top trending songs 2024");
  }

  static Future<List<Map<String, dynamic>>> getMoodBasedPlaylists(String mood) async {
    return await search("$mood songs playlist");
  }
}
