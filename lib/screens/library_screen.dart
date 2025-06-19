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
import 'package:world_music_nancy/widgets/playlist_card.dart';
import 'package:world_music_nancy/widgets/neon_aware_button.dart';

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
            RecentlyPlayedTile(song: dummySong, onTap: () {}),
            const SizedBox(height: 10),
            HistoryTile(song: dummySong, onTap: () {}),
            const SizedBox(height: 10),
            DownloadButton(onPressed: () {}), // ✅ fixed: used onPressed
            const SizedBox(height: 20),

            _sectionHeader(context, "Saved Playlists", onViewAll: () {
              Navigator.pushNamed(context, '/playlist');
            }),

            const SizedBox(height: 10),
            SizedBox(
              height: 180,
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: [
                  PlaylistCard(
                    title: "❤️ Romantic Hits",
                    imageUrl: "https://img.youtube.com/vi/Umqb9KENgmk/0.jpg",
                    onTap: () {},
                  ),
                  const SizedBox(width: 12),
                  PlaylistCard(
                    title: "🔥 Workout Bangers",
                    imageUrl: "https://img.youtube.com/vi/FYVvE4tr2BI/0.jpg",
                    onTap: () {},
                  ),
                  const SizedBox(width: 12),
                  PlaylistCard(
                    title: "🌙 Chill Nights",
                    imageUrl: "https://img.youtube.com/vi/dummy/0.jpg",
                    onTap: () {},
                  ),
                ],
              ),
            ),

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
                Navigator.pushNamed(context, '/playlist');
              },
            ),

            const SizedBox(height: 20),
            ThemeSelector(themes: NeonThemes.themes),
            const SizedBox(height: 10),
            SettingsTile(
              icon: Icons.settings,
              title: 'App Settings',
              onTap: () {
                Navigator.pushNamed(context, '/profile'); // Update route if needed
              },
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
            onPressed: onViewAll, // ✅ fixed: was `onTap`
            child: const Text("View All", style: TextStyle(color: Colors.pinkAccent)),
          ),
      ],
    );
  }
}
