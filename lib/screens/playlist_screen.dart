import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:world_music_nancy/components/base_screen.dart';
import 'package:world_music_nancy/providers/playlist_provider.dart';
import 'package:world_music_nancy/widgets/playlist_tile.dart';
import 'package:world_music_nancy/models/playlist_model.dart';
import 'package:world_music_nancy/components/custom_app_bar.dart';

class PlaylistScreen extends StatelessWidget {
  const PlaylistScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final playlists = context.watch<PlaylistProvider>().playlists;

    return BaseScreen(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: const CustomAppBar(title: 'Your Playlists'),
        body: playlists.isEmpty
            ? const Center(
                child: Text(
                  "No playlists found.",
                  style: TextStyle(color: Colors.white),
                ),
              )
            : ListView.builder(
                itemCount: playlists.length,
                itemBuilder: (context, index) {
                  final PlaylistModel model = playlists[index];
                  final playlist = model.toPlaylist(
                    id: model.name.hashCode.toString(),
                    createdBy: "Me",
                  );
                  return PlaylistTile(playlist: playlist);
                },
              ),
      ),
    );
  }
}
