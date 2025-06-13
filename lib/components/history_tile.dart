
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
      leading: Image.network(
        song.thumbnailUrl ?? '',
        width: 50,
        height: 50,
        fit: BoxFit.cover,
        errorBuilder: (_, __, ___) => const Icon(Icons.music_note, color: Colors.white),
      ),
      title: Text(
        song.title,
        style: const TextStyle(color: Colors.white),
      ),
      subtitle: Text(
        song.artist ?? '',
        style: const TextStyle(color: Colors.white54),
      ),
      trailing: const Icon(Icons.history, color: Colors.deepPurpleAccent),
      onTap: onTap,
    );
  }
}
