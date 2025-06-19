import 'package:flutter/material.dart';

class DownloadButton extends StatelessWidget {
  final VoidCallback onTap;
  final bool isDownloaded;

  const DownloadButton({
    super.key,
    required this.onTap,
    this.isDownloaded = false,
  });

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(
        isDownloaded ? Icons.download_done : Icons.download,
        color: isDownloaded ? Colors.greenAccent : Colors.white,
      ),
      onPressed: onTap,
      tooltip: isDownloaded ? 'Downloaded' : 'Download',
    );
  }
}
