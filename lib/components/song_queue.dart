# lib/components/song_queue.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:nancy_music_world/lib/providers/song_provider.dart';
import 'package:nancy_music_world/lib/widgets/song_tile.dart';

class SongQueue extends StatelessWidget {
  const SongQueue({super.key});

  @override
  Widget build(BuildContext context) {
    final songProvider = Provider.of<SongProvider>(context);
    final queue = songProvider.songQueue;

    return queue.isEmpty
        ? const Center(
            child: Text(
              'Queue is empty.',
              style: TextStyle(color: Colors.white70),
            ),
          )
        : ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: queue.length,
            itemBuilder: (context, index) {
              final song = queue[index];
              return SongTile(
                song: song,
                onTap: () => songProvider.playSong(song),
              );
            },
          );
  }
}
