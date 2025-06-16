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
      thumbnailUrl: '',
      url: '',
      channel: '',
      id: 'dummy-id',
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
              onTap: () {
                // Example navigation: Navigator.pushNamed(context, '/player');
              },
            ),
            const SizedBox(height: 10),
            HistoryTile(
              song: dummySong,
              onTap: () {
                // Example navigation: Navigator.pushNamed(context, '/historyDetail');
              },
            ),
            const SizedBox(height: 10),
            DownloadButton(
              onPressed: () {
                // Example action: download a test song
              },
            ),
            const SizedBox(height: 10),
            ThemeSelector(
              themes: availableNeonThemes,
            ),
            const SizedBox(height: 10),
            SettingsTile(
              icon: Icons.settings,
              title: 'App Settings',
              onTap: () {
                // Example: Navigator.pushNamed(context, '/settings');
              },
            ),
          ],
        ),
      ),
    );
  }
}
