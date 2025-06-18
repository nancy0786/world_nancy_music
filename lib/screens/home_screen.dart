import 'package:flutter/material.dart';
import 'package:world_music_nancy/widgets/section_title.dart';
import 'package:world_music_nancy/widgets/playlist_card.dart';
import 'package:world_music_nancy/services/storage_service.dart';
import 'package:world_music_nancy/models/song_model.dart';
import 'package:world_music_nancy/components/base_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<SongModel> _recentlyPlayed = [];
  List<Map<String, dynamic>> _playlists = [];

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    final recents = await StorageService.getHistory();
    final customPlaylists = await StorageService.getPlaylists(); // Your service
    setState(() {
      _recentlyPlayed = recents;
      _playlists = customPlaylists;
    });
  }

  @override
  Widget build(BuildContext context) {
    return BaseScreen(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          backgroundColor: Colors.black,
          centerTitle: true,
          title: const Text(
            '🎵 Nancy Music World',
            style: TextStyle(
              color: Color(0xFF00FFFF),
              fontWeight: FontWeight.bold,
              fontSize: 22,
              letterSpacing: 1.5,
            ),
          ),
        ),
        body: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            const SectionTitle(title: "Recently Played"),
            ..._recentlyPlayed.map((song) => ListTile(
                  leading: Image.network(song.thumbnailUrl, width: 50, height: 50, fit: BoxFit.cover),
                  title: Text(song.title, style: const TextStyle(color: Colors.white)),
                  subtitle: Text(song.artist, style: const TextStyle(color: Colors.white70)),
                  onTap: () {
                    // TODO: Play song
                  },
                )),

            const SizedBox(height: 20),
            const SectionTitle(title: "🔥 Top 20 Weekly"),
            SizedBox(
              height: 150,
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: _playlists.map((playlist) {
                  final firstSong = (playlist['songs'] as List).isNotEmpty ? playlist['songs'][0] : null;
                  final thumb = firstSong != null ? firstSong['thumbnail'] ?? '' : '';
                  return PlaylistCard(
                    title: playlist['name'],
                    thumbnailUrl: thumb,
                    onTap: () {
                      // TODO: Navigate to playlist screen
                    },
                  );
                }).toList(),
              ),
            ),

            const SizedBox(height: 20),
            const SectionTitle(title: "❤️ Romantic Songs"),
            SizedBox(
              height: 150,
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: _playlists
                    .where((p) => p['name'].toLowerCase().contains("romantic"))
                    .map((playlist) {
                      final first = playlist['songs'].isNotEmpty ? playlist['songs'][0] : null;
                      return PlaylistCard(
                        title: playlist['name'],
                        thumbnailUrl: first != null ? first['thumbnail'] ?? '' : '',
                        onTap: () {
                          // TODO: Navigate to playlist
                        },
                      );
                    })
                    .toList(),
              ),
            ),

            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }
}
