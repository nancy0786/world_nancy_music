import 'package:world_music_nancy/widgets/neon_aware_tile.dart';
import 'package:flutter/material.dart';
import 'package:world_music_nancy/widgets/section_title.dart';
import 'package:world_music_nancy/widgets/playlist_card.dart';
import 'package:world_music_nancy/services/storage_service.dart';
import 'package:world_music_nancy/models/song_model.dart';
import 'package:world_music_nancy/components/base_screen.dart';
import 'package:world_music_nancy/widgets/now_playing_card.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<SongModel> _recentlyPlayed = [];
  List<Map<String, dynamic>> _playlists = [];
  Map<String, String>? _lastPlayed;

  @override
  void initState() {
    super.initState();
    _loadData();
    _loadLastPlayed();
  }

  Future<void> _loadData() async {
    final recents = await StorageService.getHistory();
    final customPlaylists = await StorageService.getPlaylists();
    setState(() {
      _recentlyPlayed = recents.map((e) => SongModel(
        title: e['title'] ?? '',
        artist: e['channel'] ?? '',
        thumbnailUrl: e['thumbnail'] ?? '',
        url: e['url'] ?? '',
        channel: e['channel'] ?? '',
        id: e['id'] ?? '',
        thumbnail: e['thumbnail'] ?? '',
      )).toList();
      _playlists = customPlaylists;
    });
  }

  Future<void> _loadLastPlayed() async {
    final data = await StorageService.getLastPlayed();
    setState(() => _lastPlayed = data);
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
            ..._recentlyPlayed.map((song) => NeonAwareTile(
              leading: Image.network(song.thumbnailUrl ?? '', width: 50, height: 50, fit: BoxFit.cover),
              title: Text(song.title ?? '', style: const TextStyle(color: Colors.white)),
              subtitle: Text(song.artist ?? '', style: const TextStyle(color: Colors.white70)),
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
                    title: playlist['title'] ?? '',
                    imageUrl: thumb,
                    onTap: () {
                      // TODO: Open playlist
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
                    .where((p) => (p['title'] ?? '').toLowerCase().contains("romantic"))
                    .map((playlist) {
                      final first = playlist['songs'].isNotEmpty ? playlist['songs'][0] : null;
                      final thumb = first != null ? first['thumbnail'] ?? '' : '';
                      return PlaylistCard(
                        title: playlist['title'] ?? '',
                        imageUrl: thumb,
                        onTap: () {
                          // TODO: Open romantic playlist
                        },
                      );
                    }).toList(),
              ),
            ),

            const SizedBox(height: 30),

            /// ✅ Now Playing Card at bottom
            NowPlayingCard(
              title: _lastPlayed?['title'],
              artist: _lastPlayed?['channel'],
              thumbnailUrl: _lastPlayed?['thumbnail'],
              audioUrl: _lastPlayed?['url'],
            ),
          ],
        ),
      ),
    );
  }
}
