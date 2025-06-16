import 'package:flutter/material.dart';
import 'package:world_music_nancy/components/base_screen.dart';
import 'package:world_music_nancy/components/recently_played_tile.dart';
import 'package:world_music_nancy/components/history_tile.dart';
import 'package:world_music_nancy/components/download_button.dart';
import 'package:world_music_nancy/components/settings_tile.dart';
import 'package:world_music_nancy/widgets/theme_selector.dart';
import 'package:world_music_nancy/components/custom_app_bar.dart';
import 'package:world_music_nancy/utils/neon_themes.dart';
import 'package:world_music_nancy/models/song_model.dart';

class LibraryScreen extends StatelessWidget {
  const LibraryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final dummySong = SongModel(
      title: 'Sample Song',
      artist: 'Unknown Artist',
      thumbnail: '',
      url: '',
      id: '',
    );

    return BaseScreen(
      child: Scaffold(
        appBar: const CustomAppBar(title: 'Library'),
        backgroundColor: Colors.transparent,
        body: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            RecentlyPlayedTile(
              song: dummySong,
              onTap: () {}, // TODO: Replace with actual navigation
            ),
            const SizedBox(height: 10),
            HistoryTile(
              song: dummySong,
              onTap: () {}, // TODO: Replace with actual navigation
            ),
            const SizedBox(height: 10),
            DownloadButton(
              onPressed: () {
                // TODO: Add functionality
              },
            ),
            const SizedBox(height: 10),
            ThemeSelector(
              themes: availableNeonThemes, // <-- Ensure this list exists
            ),
            const SizedBox(height: 10),
            SettingsTile(
              icon: Icons.settings,
              title: 'App Settings',
              onTap: () {
                // TODO: Navigate to settings screen
              },
            ),
          ],
        ),
      ),
    );
  }
}
