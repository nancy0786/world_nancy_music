import 'package:flutter/material.dart';
import 'package:world_music_nancy/components/recently_played_tile.dart';
import 'package:world_music_nancy/components/history_tile.dart';
import 'package:world_music_nancy/components/download_button.dart';
import 'package:world_music_nancy/components/settings_tile.dart';
import 'package:world_music_nancy/widgets/theme_selector.dart';
import 'package:world_music_nancy/components/custom_app_bar.dart';
import 'package:world_music_nancy/utils/neon_themes.dart'; // <-- Added this

class LibraryScreen extends StatelessWidget {
  const LibraryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text('Library'),
        backgroundColor: Colors.deepPurpleAccent,
      ),
      body: ListView(
        children: [
          SettingsTile(
            icon: Icons.favorite,
            title: 'Favorite Songs',
            onTap: () => Navigator.pushNamed(context, '/favorites'),
          ),
          SettingsTile(
            icon: Icons.download,
            title: 'Downloads',
            onTap: () => Navigator.pushNamed(context, '/downloads'),
          ),
          SettingsTile(
            icon: Icons.history,
            title: 'Recently Played',
            onTap: () => Navigator.pushNamed(context, '/history'),
          ),
          SettingsTile(
            icon: Icons.queue_music,
            title: 'Playlists',
            onTap: () => Navigator.pushNamed(context, '/playlist'),
          ),
          ThemeSelector(
            themes: NeonThemes.themes, // <-- Unified with ThemeProvider
          ),
        ],
      ),
    );
  }
}
