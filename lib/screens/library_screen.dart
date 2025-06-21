import 'package:flutter/material.dart';
import 'package:world_music_nancy/components/base_screen.dart';
import 'package:world_music_nancy/components/download_button.dart';
import 'package:world_music_nancy/components/settings_tile.dart';
import 'package:world_music_nancy/widgets/theme_selector.dart';
import 'package:world_music_nancy/components/custom_app_bar.dart';
import 'package:world_music_nancy/utils/neon_themes.dart';
import 'package:world_music_nancy/widgets/neon_aware_button.dart';

class LibraryScreen extends StatelessWidget {
  const LibraryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BaseScreen(
      child: Scaffold(
        appBar: const CustomAppBar(title: 'Library'),
        backgroundColor: Colors.transparent,
        body: Column(
          children: [
            Expanded(
              child: ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  DownloadButton(onPressed: () {}),

                  const SizedBox(height: 20),

                  _sectionHeader(context, "Saved Playlists", onViewAll: () {
                    Navigator.pushNamed(context, '/savedPlaylists');
                  }),

                  const SizedBox(height: 10),

                  // Playlist cards will now be fetched dynamically inside savedPlaylists screen

                  const SizedBox(height: 30),

                  NeonAwareButton(
                    icon: Icons.playlist_add,
                    text: "Create Playlist",
                    onTap: () {
                      Navigator.pushNamed(context, '/createPlaylist');
                    },
                  ),
                  const SizedBox(height: 10),
                  NeonAwareButton(
                    icon: Icons.favorite,
                    text: "Favourite Songs",
                    onTap: () {
                      Navigator.pushNamed(context, '/favorites');
                    },
                  ),
                  const SizedBox(height: 10),
                  NeonAwareButton(
                    icon: Icons.edit_note_rounded,
                    text: "View / Edit Playlists",
                    onTap: () {
                      Navigator.pushNamed(context, '/savedPlaylists');
                    },
                  ),

                  const SizedBox(height: 20),
                  ThemeSelector(themes: NeonThemes.themes),
                  const SizedBox(height: 10),
                  SettingsTile(
                    icon: Icons.settings,
                    title: 'App Settings',
                    onTap: () {
                      Navigator.pushNamed(context, '/profile');
                    },
                  ),
                ],
              ),
            ),

            // 🎵 Mini Player Placeholder
            GestureDetector(
              onTap: () {
                Navigator.pushNamed(context, '/player');
              },
              child: Container(
                height: 60,
                color: Colors.black87,
                alignment: Alignment.center,
                child: const Text(
                  '🎵 Mini Player - Tap to open Player Screen',
                  style: TextStyle(color: Colors.white70),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _sectionHeader(BuildContext context, String title, {VoidCallback? onViewAll}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: const TextStyle(
            color: Colors.cyanAccent,
            fontSize: 18,
            fontWeight: FontWeight.bold,
            shadows: [Shadow(color: Colors.pinkAccent, blurRadius: 6)],
          ),
        ),
        if (onViewAll != null)
          TextButton(
            onPressed: onViewAll,
            child: const Text("View All", style: TextStyle(color: Colors.pinkAccent)),
          ),
      ],
    );
  }
}
