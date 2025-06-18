import 'package:world_music_nancy/widgets/neon_aware_tile.dart';
import 'package:world_music_nancy/widgets/neon_aware_tile.dart';
import 'package:flutter/material.dart';

class SongCard extends StatelessWidget {
  final String title;
  final String artist;
  final String image;
  final VoidCallback onTap;

  const SongCard({
    super.key,
    required this.title,
    required this.artist,
    required this.image,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return NeonAwareTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      leading: ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: Image.asset(
          image,
          width: 60,
          height: 60,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) => const Icon(Icons.music_note, size: 60, color: Colors.white70),
        ),
      ),
      title: Text(
        title,
        style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
      ),
      subtitle: Text(
        artist,
        style: const TextStyle(color: Colors.white70),
      ),
      onTap: onTap,
    );
  }
}
