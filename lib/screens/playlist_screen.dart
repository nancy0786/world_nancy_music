import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:world_music_nancy/providers/playlist_provider.dart';
import 'package:world_music_nancy/widgets/playlist_tile.dart'; // <-- ADDED
import 'package:world_music_nancy/models/playlist.dart';
import 'package:world_music_nancy/components/cyberpunk_card.dart';
import 'package:world_music_nancy/components/custom_app_bar.dart';
class PlaylistScreen extends StatelessWidget {
  const PlaylistScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final playlists = context.watch<PlaylistProvider>().playlists;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Playlists'),
        backgroundColor: Colors.deepPurpleAccent,
      ),
      backgroundColor: Colors.black,
      body: playlists.isEmpty
          ? const Center(
              child: Text(
                'No playlists yet.',
                style: TextStyle(color: Colors.white70),
              ),
            )
          : ListView.builder(
              itemCount: playlists.length,
              itemBuilder: (context, index) {
                final playlist = playlists[index];
                return PlaylistTile(
                  playlist: playlist,
                  onTap: () {
                    Navigator.pushNamed(
                      context,
                      '/playlistDetails',
                      arguments: playlist,
                    );
                  },
                  onDelete: () {
                    context.read<PlaylistProvider>().deletePlaylist(playlist.name);
                  },
                );
              },
            ),
    );
  }
}
