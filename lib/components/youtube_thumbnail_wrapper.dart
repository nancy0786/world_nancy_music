import 'package:world_music_nancy/widgets/neon_aware_container.dart';
import 'package:world_music_nancy/widgets/neon_aware_container.dart';

import 'package:flutter/material.dart';

class YouTubeThumbnailWrapper extends StatelessWidget {
  final String videoId;
  final double width;
  final double height;
  final VoidCallback? onTap;

  const YouTubeThumbnailWrapper({
    super.key,
    required this.videoId,
    this.width = double.infinity,
    this.height = 200,
    this.onTap,
  });

  String get thumbnailUrl =>
      'https://img.youtube.com/vi/$videoId/hqdefault.jpg';

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: Stack(
          alignment: Alignment.center,
          children: [
            Image.network(
              thumbnailUrl,
              width: width,
              height: height,
              fit: BoxFit.cover,
              loadingBuilder: (context, child, loadingProgress) {
                if (loadingProgress == null) return child;
                return NeonAwareContainer(
                  width: width,
                  height: height,
                  color: Colors.black12,
                  child: const Center(
                    child: CircularProgressIndicator(
                      color: Colors.deepPurpleAccent,
                    ),
                  ),
                );
              },
              errorBuilder: (context, error, stackTrace) {
                return NeonAwareContainer(
                  width: width,
                  height: height,
                  color: Colors.grey[900],
                  child: const Icon(Icons.error, color: Colors.white),
                );
              },
            ),
            const Icon(Icons.play_circle, size: 60, color: Colors.white70),
          ],
        ),
      ),
    );
  }
}
