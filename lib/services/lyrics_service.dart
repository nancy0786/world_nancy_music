// lib/services/lyrics_service.dart

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart';

class LyricsService {
  static const _sources = [
    'https://api.lyrics.ovh/v1', // Free lyrics API
    // You can add more APIs here if needed
  ];

  static Future<String?> fetchLyrics(String artist, String title) async {
    for (final base in _sources) {
      try {
        final response = await http.get(Uri.parse('$base/$artist/$title'));
        if (response.statusCode == 200) {
          final data = jsonDecode(response.body);
          if (data['lyrics'] != null && data['lyrics'].toString().trim().isNotEmpty) {
            return data['lyrics'];
          }
        }
      } catch (e) {
        debugPrint('Lyrics fetch error from $base: $e');
        continue;
      }
    }
    return null;
  }
}
