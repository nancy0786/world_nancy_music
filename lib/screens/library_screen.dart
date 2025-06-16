import 'package:flutter/material.dart';
import 'package:world_music_nancy/components/base_screen.dart';
import 'package:world_music_nancy/components/recently_played_tile.dart';
import 'package:world_music_nancy/components/history_tile.dart';
import 'package:world_music_nancy/components/download_button.dart';
import 'package:world_music_nancy/components/settings_tile.dart';
import 'package:world_music_nancy/widgets/theme_selector.dart';
import 'package:world_music_nancy/components/custom_app_bar.dart';
import 'package:world_music_nancy/utils/neon_themes.dart';

class LibraryScreen extends StatelessWidget {
  const LibraryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BaseScreen(
      child: Scaffold(
        appBar: const CustomAppBar(title: 'Library'),
        backgroundColor: Colors.transparent,
        body: ListView(
          padding: const EdgeInsets.all(16),
          children: const [
            RecentlyPlayedTile(),
            SizedBox(height: 10),
            HistoryTile(),
            SizedBox(height: 10),
            DownloadButton(),
            SizedBox(height: 10),
            ThemeSelector(),
            SizedBox(height: 10),
            SettingsTile(),
          ],
        ),
      ),
    );
  }
}
