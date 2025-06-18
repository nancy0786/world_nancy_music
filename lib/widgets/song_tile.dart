import 'package:world_music_nancy/widgets/neon_aware_tile.dart';
import 'package:world_music_nancy/widgets/neon_aware_tile.dart';
import 'package:flutter/material.dart';

class SongTile extends StatelessWidget {
  final String title;
  final String thumbnailUrl;
  final VoidCallback onTap;
  final VoidCallback? onDownloadTap;

  const SongTile({
    super.key,
    required this.title,
    required this.thumbnailUrl,
    required this.onTap,
    this.onDownloadTap,
  });

  @override
  Widget build(BuildContext context) {
    return NeonAwareTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      tileColor: Colors.grey[900],
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      leading: ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: Image.network(
          thumbnailUrl,
          width: 50,
          height: 50,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) => const Icon(
            Icons.music_note,
            color: Colors.white,
          ),
        ),
      ),
      title: Text(
        title,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 16,
          fontWeight: FontWeight.w500,
        ),
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
      ),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (onDownloadTap != null)
            IconButton(
              icon: const Icon(Icons.download, color: Colors.cyanAccent),
              onPressed: onDownloadTap,
              tooltip: 'Download',
            ),
          IconButton(
            icon: const Icon(Icons.play_arrow, color: Colors.tealAccent),
            onPressed: onTap,
            tooltip: 'Play',
          ),
        ],
      ),
      onTap: onTap,
    );
  }
}
