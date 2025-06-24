import 'package:flutter/services.dart';

class YtDlpService {
  static const platform = MethodChannel('yt_dlp');

  static Future<Map<String, dynamic>?> getAudioStream(String videoUrl) async {
    try {
      final result = await platform.invokeMethod('getAudioUrl', {'url': videoUrl});
      return Map<String, dynamic>.from(result);
    } catch (e) {
      print("YTDLP error: $e");
      return null;
    }
  }
}
