import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart';

class LyricsService {
  static const _sources = [
    _getOVHLyrics,
    _getGeniusLyrics,
    _getKSoftLyrics, // Example of synced lyrics (if available)
  ];

  /// Main method to fetch lyrics. Returns:
  /// - 'lyrics' as String (with or without timestamps)
  /// - or null if not found
  static Future<String?> fetchLyrics(String artist, String title) async {
    for (final source in _sources) {
      try {
        final lyrics = await source(artist, title);
        if (lyrics != null && lyrics.trim().isNotEmpty) {
          return lyrics;
        }
      } catch (e) {
        debugPrint('Lyrics fetch error: $e');
        continue;
      }
    }
    return null;
  }

  /// 1️⃣ OVH API (no timestamps)
  static Future<String?> _getOVHLyrics(String artist, String title) async {
    final url = 'https://api.lyrics.ovh/v1/${Uri.encodeComponent(artist)}/${Uri.encodeComponent(title)}';
    final res = await http.get(Uri.parse(url));
    if (res.statusCode == 200) {
      final data = jsonDecode(res.body);
      return data['lyrics'];
    }
    return null;
  }

  /// 2️⃣ Genius API (scraping unofficially)
  static Future<String?> _getGeniusLyrics(String artist, String title) async {
    final query = Uri.encodeComponent('$title $artist lyrics');
    final url = 'https://some-random-api.ml/lyrics?title=$query'; // example proxy
    final res = await http.get(Uri.parse(url));
    if (res.statusCode == 200) {
      final data = jsonDecode(res.body);
      return data['lyrics'];
    }
    return null;
  }

  /// 3️⃣ KSoft API (might return synced lyrics if subscribed)
  static Future<String?> _getKSoftLyrics(String artist, String title) async {
    const apiKey = 'YOUR_KSOFT_API_KEY';
    final query = Uri.encodeComponent('$title $artist');
    final url = 'https://api.ksoft.si/lyrics/search?q=$query';
    final res = await http.get(
      Uri.parse(url),
      headers: {'Authorization': 'Bearer $apiKey'},
    );
    if (res.statusCode == 200) {
      final data = jsonDecode(res.body);
      if (data['data'] != null && data['data'].isNotEmpty) {
        return data['data'][0]['lyrics'];
      }
    }
    return null;
  }
}
