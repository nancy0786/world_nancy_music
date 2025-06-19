import 'package:flutter/material.dart';

class DownloadButton extends StatelessWidget {
  final VoidCallback onPressed; // ✅ Renamed from onTap to onPressed
  final bool isDownloaded;

  const DownloadButton({
    super.key,
    required this.onPressed, // ✅ Use onPressed
    this.isDownloaded = false,
  });

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(
        isDownloaded ? Icons.download_done : Icons.download,
        color: isDownloaded ? Colors.greenAccent : Colors.white,
      ),
      onPressed: onPressed, // ✅ Correct usage
      tooltip: isDownloaded ? 'Downloaded' : 'Download',
    );
  }
}
