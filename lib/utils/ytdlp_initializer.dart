import 'dart:io';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';

class YtDlpInitializer {
  static Future<String> prepareYtDlp() async {
    // Load yt-dlp binary from assets
    final byteData = await rootBundle.load('assets/yt-dlp');

    // Get temp directory to save the executable
    final tempDir = await getTemporaryDirectory();
    final ytDlpPath = '${tempDir.path}/yt-dlp';
    final ytDlpFile = File(ytDlpPath);

    // Write binary to temp file
    await ytDlpFile.writeAsBytes(byteData.buffer.asUint8List());

    // Make it executable using chmod
    await Process.run('chmod', ['+x', ytDlpFile.path]);

    // Return the path to be used for running
    return ytDlpFile.path;
  }
}
