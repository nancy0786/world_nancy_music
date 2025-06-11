import 'package:flutter/material.dart';
import 'package:nancy_music_world/components/recently_played_tile.dart';
import 'package:nancy_music_world/components/history_tile.dart';
import 'package:nancy_music_world/components/download_button.dart';
import 'package:nancy_music_world/components/settings_tile.dart';
import 'package:nancy_music_world/widgets/theme_selector.dart';
import 'package:nancy_music_world/components/custom_app_bar.dart';

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
          ThemeSelector(), // 👈 Add this widget
        ],
      ),
    );
  }
}
