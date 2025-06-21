import 'package:youtube_explode_dart/youtube_explode_dart.dart';
import 'package:flutter/foundation.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class YouTubeService {
  static final YoutubeExplode _yt = YoutubeExplode();

  static const String apiKey = 'AIzaSyCrKr-n_iRaLmLjT-qwKnYe_b6BHatvGl8';
  static const String baseUrl = 'https://www.googleapis.com/youtube/v3';

  /// 🔊 Get high-quality direct audio stream for a YouTube video
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
      debugPrint('Error fetching audio stream: $e');
      return null;
    }
  }

  /// 🔍 YouTube search using official API (more stable than youtube_explode_dart)
  static Future<List<Map<String, String>>> search(String query) async {
    try {
      final url = Uri.parse(
        '$baseUrl/search?part=snippet&type=video&maxResults=25&q=${Uri.encodeComponent(query)}&key=$apiKey',
      );

      final response = await http.get(url);
      if (response.statusCode != 200) {
        debugPrint('Search failed: ${response.body}');
        return [];
      }

      final data = jsonDecode(response.body);
      final List items = data['items'];

      return items.map<Map<String, String>>((item) {
        final snippet = item['snippet'];
        return {
          'videoId': item['id']['videoId'],
          'title': snippet['title'],
          'thumbnail': snippet['thumbnails']['high']['url'],
          'channel': snippet['channelTitle'],
        };
      }).toList();
    } catch (e) {
      debugPrint('Search error: $e');
      return [];
    }
  }

  /// 📺 Load all videos from a YouTube playlist using API v3
  static Future<List<Map<String, String>>> getSongsFromPlaylist(String playlistId) async {
    List<Map<String, String>> allVideos = [];
    String? nextPageToken;

    try {
      do {
        final url = Uri.parse(
          '$baseUrl/playlistItems?part=snippet&maxResults=50&playlistId=$playlistId&pageToken=${nextPageToken ?? ""}&key=$apiKey',
        );

        final response = await http.get(url);
        if (response.statusCode != 200) {
          debugPrint("Playlist error: ${response.statusCode}");
          break;
        }

        final data = jsonDecode(response.body);
        final items = data['items'] as List;
        nextPageToken = data['nextPageToken'];

        final parsedItems = items.map<Map<String, String>>((item) {
          final snippet = item['snippet'];
          return {
            'title': snippet['title'] ?? '',
            'channel': snippet['videoOwnerChannelTitle'] ?? '',
            'videoId': snippet['resourceId']['videoId'] ?? '',
            'thumbnail': snippet['thumbnails']?['medium']?['url'] ?? '',
            'url': 'https://www.youtube.com/watch?v=${snippet['resourceId']['videoId']}',
          };
        }).toList();

        allVideos.addAll(parsedItems);
      } while (nextPageToken != null);
    } catch (e) {
      debugPrint('getSongsFromPlaylist error: $e');
    }

    return allVideos;
  }

  /// 🎵 Curated playlists to be used on the Home screen (can be dynamic later)
  static Future<List<Map<String, String>>> getMusicPlaylists() async {
    return [
      {
        'title': 'Romantic Hits',
        'playlistId': 'PLFgquLnL59alCl_2TQvOiD5Vgm1hCaGSI',
        'thumbnail': 'https://img.youtube.com/vi/8ZcmTl_1ER8/mqdefault.jpg',
      },
      {
        'title': 'Trending India',
        'playlistId': 'PLrEnWoR732-BHrPp_Pm8_VleD68f9s14-',
        'thumbnail': 'https://img.youtube.com/vi/DhWFGTSqkCU/mqdefault.jpg',
      },
      {
        'title': 'Bollywood Chill',
        'playlistId': 'PLRBp0Fe2GpglkQ6w0DLy3ApK_M5BXrbSp',
        'thumbnail': 'https://img.youtube.com/vi/0J2QdDbelmY/mqdefault.jpg',
      }
    ];
  }

  /// 🤖 YouTube Autocomplete Suggestions (not from API, but reliable)
  static Future<List<String>> fetchSuggestions(String query) async {
    final suggestUrl = Uri.parse(
      'https://suggestqueries.google.com/complete/search?client=firefox&ds=yt&q=${Uri.encodeComponent(query)}',
    );
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

  /// 🧹 Clean up
  static void dispose() {
    _yt.close();
  }
}
