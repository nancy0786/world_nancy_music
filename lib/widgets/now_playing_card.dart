import 'package:world_music_nancy/widgets/neon_aware_tile.dart';
import 'package:world_music_nancy/widgets/neon_aware_card.dart';
import 'package:flutter/material.dart';

class NowPlayingCard extends StatelessWidget {
  final String? title;
  final String? artist;
  final String? thumbnailUrl;
  final String? audioUrl;
  final VoidCallback? onTap;

  const NowPlayingCard({
    super.key,
    this.title,
    this.artist,
    this.thumbnailUrl,
    this.audioUrl,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    if (title == null || audioUrl == null || audioUrl!.isEmpty) {
      return const SizedBox.shrink(); // Hide if nothing is playing
    }

    return GestureDetector(
      onTap: onTap,
      child: NeonAwareCard(
        color: Colors.black.withOpacity(0.7),
        margin: const EdgeInsets.only(bottom: 12),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: NeonAwareTile(
          leading: thumbnailUrl != null && thumbnailUrl!.isNotEmpty
              ? Image.network(thumbnailUrl!, width: 50, height: 50, fit: BoxFit.cover)
              : const Icon(Icons.music_note, color: Colors.white),
          title: Text(title!, style: const TextStyle(color: Colors.white)),
          subtitle: Text(artist ?? '', style: const TextStyle(color: Colors.white70)),
          trailing: const Icon(Icons.expand_less, color: Colors.cyanAccent),
        ),
      ),
    );
  }
}
