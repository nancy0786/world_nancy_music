cat > lib/services/download_manager.dart << 'EOF'
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:youtube_explode_dart/youtube_explode_dart.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DownloadManager {
  static Future<String?> downloadAudio(String videoUrl) async {
    final yt = YoutubeExplode();
    final videoId = VideoId.parseVideoId(videoUrl);
    if (videoId == null) return null;

    final video = await yt.videos.get(videoId);
    final manifest = await yt.videos.streamsClient.getManifest(videoId);
    final audioStream = manifest.audioOnly.withHighestBitrate();
    final stream = yt.videos.streamsClient.get(audioStream);

    final dir = await getApplicationDocumentsDirectory();
    final filePath = '${dir.path}/${videoId}.mp3';
    final file = File(filePath);

    final output = file.openWrite();
    await stream.pipe(output);
    await output.flush();
    await output.close();

    await yt.close();

    final prefs = await SharedPreferences.getInstance();
    List<String> downloads = prefs.getStringList('downloads') ?? [];
    downloads.add('${video.title}|${filePath}|${video.thumbnails.highResUrl}');
    await prefs.setStringList('downloads', downloads);

    return filePath;
  }

  static Future<List<Map<String, String>>> getDownloadedSongs() async {
    final prefs = await SharedPreferences.getInstance();
    final downloads = prefs.getStringList('downloads') ?? [];
    return downloads.map((item) {
      final parts = item.split('|');
      return {
        'title': parts[0],
        'path': parts[1],
        'thumbnail': parts[2],
      };
    }).toList();
  }
}
EOF
