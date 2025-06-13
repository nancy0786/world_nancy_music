
import 'package:flutter/material.dart';
import 'package:world_music_nancy/models/song_model.dart';

class RecentlyPlayedTile extends StatelessWidget {
  final SongModel song;
  final VoidCallback onTap;

  const RecentlyPlayedTile({
    super.key,
    required this.song,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Image.network(
        song.thumbnail,
        width: 50,
        height: 50,
        fit: BoxFit.cover,
      ),
      title: Text(
        song.title,
        style: const TextStyle(color: Colors.white),
      ),
      subtitle: Text(
        song.artist ?? '',
        style: const TextStyle(color: Colors.white60),
      ),
      trailing: const Icon(Icons.play_arrow, color: Colors.cyanAccent),
      onTap: onTap,
    );
  }
}
