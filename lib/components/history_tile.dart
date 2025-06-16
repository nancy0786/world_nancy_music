import 'package:flutter/material.dart';
import 'package:world_music_nancy/models/song_model.dart';

class HistoryTile extends StatelessWidget {
  final SongModel song;
  final VoidCallback onTap;

  const HistoryTile({
    super.key,
    required this.song,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: song.thumbnailUrl != null && song.thumbnailUrl!.isNotEmpty
          ? Image.network(
              song.thumbnailUrl!,
              width: 50,
              height: 50,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) =>
                  const Icon(Icons.music_note, color: Colors.white),
            )
          : const Icon(Icons.music_note, color: Colors.white),
      title: Text(
        song.title.isNotEmpty ? song.title : "Unknown Title",
        style: const TextStyle(color: Colors.white),
      ),
      subtitle: Text(
        song.artist ?? "Unknown Artist",
        style: const TextStyle(color: Colors.white54),
      ),
      trailing: const Icon(Icons.history, color: Colors.deepPurpleAccent),
      onTap: onTap,
    );
  }
}
