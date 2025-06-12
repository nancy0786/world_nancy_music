import 'package:flutter/material.dart';

class YouTubeThumbnail extends StatelessWidget {
  final String videoId;

  const YouTubeThumbnail({
    super.key,
    required this.videoId,
  });

  @override
  Widget build(BuildContext context) {
    final String thumbnailUrl = 'https://img.youtube.com/vi/\$videoId/0.jpg';

    return ClipRRect(
      borderRadius: const BorderRadius.all(Radius.circular(8)),
      child: Image.network(
        thumbnailUrl,
        fit: BoxFit.cover,
        width: 100,
        height: 56,
        errorBuilder: (context, error, stackTrace) => const Icon(
          Icons.error,
          color: Colors.red,
        ),
      ),
    );
  }
}
