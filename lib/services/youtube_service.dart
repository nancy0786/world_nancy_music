import 'package:youtube_explode_dart/youtube_explode_dart.dart';
import 'package:flutter/foundation.dart';

class YouTubeService {
  static final YoutubeExplode _yt = YoutubeExplode();

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

  static Future<List<Map<String, String>>> search(String query) async {
    try {
      final results = await _yt.search.getVideos(query);
      return results.map((video) {
        return {
          'videoId': video.id.value,
          'title': video.title,
          'thumbnail': video.thumbnails.highResUrl,
          'channel': video.author, // ✅ Added this to fix subtitle
        };
      }).toList();
    } catch (e) {
      debugPrint('Search error: $e');
      return [];
    }
  }

  static void dispose() {
    _yt.close();
  }
}
