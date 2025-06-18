import 'package:world_music_nancy/widgets/neon_aware_tile.dart';
import 'package:flutter/material.dart';
import 'package:world_music_nancy/models/playlist.dart';

class PlaylistTile extends StatelessWidget {
  final Playlist playlist;
  final VoidCallback? onTap;
  final VoidCallback? onDelete;

  const PlaylistTile({
    super.key,
    required this.playlist,
    this.onTap,
    this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return NeonAwareTile(
      leading: const Icon(Icons.queue_music, color: Colors.pinkAccent),
      title: Text(
        playlist.title,
        style: const TextStyle(color: Colors.white),
      ),
      subtitle: Text(
        playlist.isPublic ? 'Public' : 'Private',
        style: const TextStyle(color: Colors.white70),
      ),
      trailing: onDelete != null
          ? IconButton(
              icon: const Icon(Icons.delete, color: Colors.redAccent),
              onPressed: onDelete,
            )
          : null,
      onTap: onTap,
    );
  }
}
