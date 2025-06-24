import 'dart:io';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';

class YtDlpInitializer {
  static Future<String> initYtDlpBinary() async {
    final dir = await getApplicationSupportDirectory();
    final ytDlpPath = '${dir.path}/yt-dlp';

    final ytDlpFile = File(ytDlpPath);

    if (!await ytDlpFile.exists()) {
      final byteData = await rootBundle.load('assets/yt-dlp');
      await ytDlpFile.writeAsBytes(byteData.buffer.asUint8List());
      await ytDlpFile.setExecutable(true);
    }

    return ytDlpPath;
  }
}
