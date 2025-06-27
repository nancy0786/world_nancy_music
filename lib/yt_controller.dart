import 'dart:io';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';

class YTDLPManager {
  static Future<String> extractBinary() async {
    final dir = await getApplicationSupportDirectory();
    final binaryPath = '${dir.path}/yt-dlp';

    final byteData = await rootBundle.load('assets/yt-dlp');
    final buffer = byteData.buffer;
    await File(binaryPath).writeAsBytes(
      buffer.asUint8List(byteData.offsetInBytes, byteData.lengthInBytes),
      flush: true,
    );

    await Process.run('chmod', ['+x', binaryPath]); // Make executable
    return binaryPath;
  }

  static Future<void> runYTDLP(String url) async {
    final binary = await extractBinary();
    final process = await Process.start(binary, [url]);

    process.stdout.transform(SystemEncoding().decoder).listen((data) {
      print("YT-DLP OUTPUT: $data");
    });

    process.stderr.transform(SystemEncoding().decoder).listen((data) {
      print("YT-DLP ERROR: $data");
    });

    await process.exitCode;
  }
}
