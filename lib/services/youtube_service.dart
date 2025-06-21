import 'package:youtube_explode_dart/youtube_explode_dart.dart';
import 'package:flutter/foundation.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class YouTubeService {
  static final YoutubeExplode _yt = YoutubeExplode();

  static const String apiKey = 'AIzaSyCrKr-n_iRaLmLjT-qwKnYe_b6BHatvGl8';
  static const String baseUrl = 'https://www.googleapis.com/youtube/v3';

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

  static Future<List<Map<String, String>>> getMusicPlaylists() async {
    final sections = [
      'Romantic Hits',
      'Bollywood Chill',
      'Monsoon Vibes',
      'Workout Motivation',
      'Old Hindi Songs',
      'Top 50 India',
      'Arijit Singh Hits',
      '90s Bollywood',
      'Indie Pop',
      'Love Anthems',
      'Sad Songs Hindi',
      'Desi EDM',
      'Atif Aslam Special',
      'Jubin Nautiyal Vibes',
      'Tulsi Kumar Mix',
    ];

    List<Map<String, String>> playlists = [];

    for (final name in sections) {
      try {
        final searchResults = await _yt.search.search(name);
        final firstPlaylist = searchResults
            .where((e) => e is Playlist)
            .cast<Playlist>()
            .first;

        playlists.add({
          'title': firstPlaylist.title,
          'playlistId': firstPlaylist.id.value,
          'thumbnail': firstPlaylist.thumbnails.highResUrl,
        });
      } catch (e) {
        debugPrint('Could not fetch playlist for "$name": $e');
      }
    }

    return playlists;
  }

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

  static void dispose() {
    _yt.close();
  }
}
