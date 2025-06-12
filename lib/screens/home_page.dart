# --------- lib/screens/home_page.dart (updated with buttons and queue support) ----------
cat > lib/screens/home_page.dart << 'EOF'
import 'package:flutter/material.dart';
import 'package:nancy_music_world/widgets/player_controls.dart';
import 'package:nancy_music_world/widgets/song_search.dart';
import 'package:nancy_music_world/widgets/theme_toggle.dart';
import 'package:nancy_music_world/widgets/background_manager.dart';
import 'package:nancy_music_world/widgets/favorites_section.dart';
import 'package:nancy_music_world/services/mood_service.dart';
import 'package:nancy_music_world/widgets/neon_theme_picker.dart';
import 'package:nancy_music_world/widgets/smart_discovery_section.dart';
import 'dart:io';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:nancy_music_world/widgets/neon_button.dart';

class HomePage extends StatelessWidget {
  final VoidCallback toggleTheme;

  const HomePage({super.key, required this.toggleTheme});

  @override
  Widget build(BuildContext context) {
    final mood = MoodService.getCurrentMood();
    final moodSongs = MoodService.getSongsForMood(mood);

    return Stack(
      children: [
        const BackgroundManager(),
        Scaffold(
          backgroundColor: Colors.transparent,
          appBar: AppBar(
            title: const Text("Nancy Music World"),
            actions: [
              IconButton(
                icon: const Icon(Icons.color_lens),
                onPressed: toggleTheme,
              ),
              IconButton(
                icon: const Icon(Icons.person),
                onPressed: () {
                  Navigator.pushNamed(context, '/profile');
                },
              ),
            ],
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: Text(
                    '🎧 Mood: $mood',
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.tealAccent,
                    ),
                  ),
                ),
                NeonButton(
  text: "➕ Create Playlist",
  icon: Icons.playlist_add,
  onTap: () {
    Navigator.pushNamed(context, '/createPlaylist');
  },
                const SizedBox(height: 20),
                FutureBuilder(
                  future: SharedPreferences.getInstance(),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) return const CircularProgressIndicator();
                    final prefs = snapshot.data!;
                    final playlists = prefs.getStringList('playlists') ?? [];

                    return Column(
                      children: playlists.map((data) {
                        final parts = data.split('|');
                        final name = parts[0];
                        final privacy = parts[1];
                        final imagePath = parts.length > 2 ? parts[2] : '';

                        return ListTile(
                          leading: imagePath.isNotEmpty
                              ? Image.file(File(imagePath), width: 50, height: 50, fit: BoxFit.cover)
                              : const Icon(Icons.music_note),
                          title: Text(name),
                          subtitle: Text(privacy.toUpperCase()),
                          onTap: () {
                            // TODO: Navigate to playlist details
                          },
                        );
                      }).toList(),
                    );
                  },
                ),
                NeonThemePicker(onThemeSelected: (theme) {
                  (context.findAncestorStateOfType<_NancyMusicWorldAppState>())?._changeTheme(theme);
                }),
                Wrap(
                  spacing: 10,
                  children: moodSongs.map((title) {
                    return ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.teal,
                        shape: const StadiumBorder(),
                      ),
                      onPressed: () {
                        Navigator.pushNamed(context, '/search', arguments: title);
                      },
                      child: Text(title),
                    );
                  }).toList(),
                ),
                const SizedBox(height: 20),
                const SmartDiscoverySection(),
                const SizedBox(height: 20),
                const PlayerControls(),
                const SizedBox(height: 20),
                const SongSearch(),
                const SizedBox(height: 20),
                const FavoritesSection(),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
EOF
