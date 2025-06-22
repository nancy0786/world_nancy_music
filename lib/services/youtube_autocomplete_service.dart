import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';

class YouTubeAutocompleteService {
  static Future<List<String>> fetchSuggestions(String query) async {
    try {
      final process = await Process.start(
        'yt-dlp',
        ['--dump-json', 'ytsearch10:$query'],
        runInShell: true,
      );

      final List<String> suggestions = [];
      final lines = await process.stdout
          .transform(utf8.decoder)
          .transform(const LineSplitter())
          .toList();

      for (final line in lines) {
        final data = jsonDecode(line);
        if (data is Map && data['title'] != null) {
          suggestions.add(data['title']);
        }
      }

      return suggestions.take(8).toList(); // Return top 8 results as suggestions
    } catch (e) {
      debugPrint("🔴 yt-dlp autocomplete error: $e");
      return [];
    }
  }
}
