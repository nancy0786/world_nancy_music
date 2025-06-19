import 'package:youtube_explode_dart/youtube_explode_dart.dart';
import 'package:flutter/foundation.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class YouTubeService {
  static final YoutubeExplode _yt = YoutubeExplode();

  // 🔐 Replace with your own YouTube Data API key
  static const String apiKey = 'AIzaSyCrKr-n_iRaLmLjT-qwKnYe_b6BHatvGl8';
  static const String baseUrl = 'https://www.googleapis.com/youtube/v3';

  /// ✅ Extract direct audio stream using youtube_explode_dart
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

  /// ✅ Search YouTube Videos
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

  /// ✅ Fetch Playlist Videos from YouTube Data API
  static Future<List<Map<String, String>>> fetchPlaylistVideos(String playlistId) async {
    try {
      final url = Uri.parse(
        '$baseUrl/playlistItems?part=snippet&maxResults=25&playlistId=$playlistId&key=$apiKey',
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
        };
      }).toList();
    } catch (e) {
      debugPrint('fetchPlaylistVideos error: $e');
      return [];
    }
  }

  /// ✅ Close the connection
  static void dispose() {
    _yt.close();
  }
}
