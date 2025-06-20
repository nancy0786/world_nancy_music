import 'package:youtube_explode_dart/youtube_explode_dart.dart';
import 'package:flutter/foundation.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class YouTubeService {
  static final YoutubeExplode _yt = YoutubeExplode();

  // 🔐 Replace with your actual API key
  static const String apiKey = 'AIzaSyCrKr-n_iRaLmLjT-qwKnYe_b6BHatvGl8';
  static const String baseUrl = 'https://www.googleapis.com/youtube/v3';

  /// 🔊 Get direct audio stream for a YouTube video
  static Future<Map<String, String>?> getAudioStream(String videoId) async {
    try {
      final video = await _yt.videos.get('https://www.youtube.com/watch?v=$videoId');
      final manifest = await _yt.videos.streamsClient.getManifest(videoId);
      final audioStream = manifest.audioOnly.withHighestBitrate();
      if (audioStream == null) return null;
      return {
        'url': audioStream.url.toString(),
        'title': video.title,
        'thumbnail': video.thumbnails.highResUrl,
      };
    } catch (e) {
      debugPrint('Error fetching YouTube stream: $e');
      return null;
    }
  }

  /// 🔍 Search videos using youtube_explode_dart (no quota)
  static Future<List<Map<String, String>>> search(String query) async {
    try {
      final results = await _yt.search.getVideos(query);
      return results.map((video) {
        return {
          'videoId': video.id.value,
          'title': video.title,
          'thumbnail': video.thumbnails.highResUrl,
          'channel': video.author,
        };
      }).toList();
    } catch (e) {
      debugPrint('Search error: $e');
      return [];
    }
  }

  /// 📺 Get videos from a YouTube playlist using official API
  static Future<List<Map<String, String>>> getSongsFromPlaylist(String playlistId) async {
    try {
      final url = Uri.parse(
        '$baseUrl/playlistItems?part=snippet&maxResults=50&playlistId=$playlistId&key=$apiKey',
      );

      final response = await http.get(url);
      if (response.statusCode != 200) {
        debugPrint("YouTube API Error: ${response.statusCode}");
        return [];
      }

      final data = jsonDecode(response.body);
      final items = data['items'] as List;

      return items.map<Map<String, String>>((item) {
        final snippet = item['snippet'];
        return {
          'title': snippet['title'] ?? '',
          'channel': snippet['videoOwnerChannelTitle'] ?? '',
          'videoId': snippet['resourceId']['videoId'] ?? '',
          'thumbnail': snippet['thumbnails']?['medium']?['url'] ?? '',
          'url': 'https://www.youtube.com/watch?v=${snippet['resourceId']['videoId']}',
        };
      }).toList();
    } catch (e) {
      debugPrint('getSongsFromPlaylist error: $e');
      return [];
    }
  }

  /// 🎵 Return a curated list of music categories with playlist ID (you can expand this)
  static Future<List<Map<String, String>>> getMusicPlaylists() async {
    final List<Map<String, String>> playlists = [
      {
        'title': 'Romantic Hits',
        'playlistId': 'PLFgquLnL59alCl_2TQvOiD5Vgm1hCaGSI',
        'thumbnail': 'https://img.youtube.com/vi/8ZcmTl_1ER8/mqdefault.jpg'
      },
      {
        'title': 'Trending India',
        'playlistId': 'PLrEnWoR732-BHrPp_Pm8_VleD68f9s14-',
        'thumbnail': 'https://img.youtube.com/vi/DhWFGTSqkCU/mqdefault.jpg'
      },
      {
        'title': 'Bollywood Chill',
        'playlistId': 'PLRBp0Fe2GpglkQ6w0DLy3ApK_M5BXrbSp',
        'thumbnail': 'https://img.youtube.com/vi/0J2QdDbelmY/mqdefault.jpg'
      }
    ];

    return playlists;
  }

  /// 🧠 Smart Autocomplete Suggestions (used in search)
  static Future<List<String>> fetchSuggestions(String query) async {
    final suggestUrl = Uri.parse('http://suggestqueries.google.com/complete/search?client=firefox&ds=yt&q=$query');
    try {
      final res = await http.get(suggestUrl);
      if (res.statusCode == 200) {
        final List data = json.decode(res.body);
        return List<String>.from(data[1]);
      }
    } catch (e) {
      debugPrint("Autocomplete error: $e");
    }
    return [];
  }

  /// ❌ Clean-up
  static void dispose() {
    _yt.close();
  }
}
