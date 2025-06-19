import 'package:flutter/material.dart';
import 'package:world_music_nancy/widgets/neon_aware_tile.dart';
import 'package:world_music_nancy/widgets/section_title.dart';
import 'package:world_music_nancy/widgets/playlist_card.dart';
import 'package:world_music_nancy/services/storage_service.dart';
import 'package:world_music_nancy/services/youtube_service.dart';
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
  List<Map<String, String>> _ytRecommendations = [];
  Map<String, String>? _lastPlayed;

  @override
  void initState() {
    super.initState();
    _loadData();
    _loadLastPlayed();
    _loadRecommendations();
  }

  Future<void> _loadData() async {
    final recents = await StorageService.getHistory();
    final customPlaylists = await StorageService.getPlaylists();
    setState(() {
      _recentlyPlayed = recents.take(30).map((e) => SongModel(
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

  Future<void> _loadRecommendations() async {
    final ytRecs = await YouTubeService.getMusicPlaylists();
    setState(() => _ytRecommendations = ytRecs);
  }

  @override
  Widget build(BuildContext context) {
    return BaseScreen(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          centerTitle: true,
          title: const Text(
            '🎶 Nancy Music World',
            style: TextStyle(
              fontFamily: 'DancingScript', // make sure font added
              color: Colors.cyanAccent,
              fontSize: 30,
              fontWeight: FontWeight.bold,
              shadows: [Shadow(color: Colors.pinkAccent, blurRadius: 4)],
            ),
          ),
        ),
        body: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: const [
                SectionTitle(title: "Recently Played"),
                Text("View All", style: TextStyle(color: Colors.cyanAccent)),
              ],
            ),
            SizedBox(
              height: 120,
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: _recentlyPlayed.map((song) {
                  return NeonAwareTile(
                    title: Text(song.title, style: const TextStyle(color: Colors.white)),
                    subtitle: Text(song.artist, style: const TextStyle(color: Colors.white70)),
                    leading: Image.network(song.thumbnailUrl ?? '', width: 50, height: 50),
                    onTap: () {
                      // TODO: Play this song
                    },
                    trailing: IconButton(
                      icon: const Icon(Icons.close, color: Colors.redAccent),
                      onPressed: () {
                        // TODO: Remove from history + undo Snackbar
                      },
                    ),
                  );
                }).toList(),
              ),
            ),
            const SizedBox(height: 24),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: const [
                SectionTitle(title: "Recommended"),
                Text("View All", style: TextStyle(color: Colors.cyanAccent)),
              ],
            ),

            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: _playlists.take(5).map((playlist) {
                      final first = playlist['songs'].isNotEmpty ? playlist['songs'][0] : null;
                      final thumb = first != null ? first['thumbnail'] ?? '' : '';
                      return PlaylistCard(
                        title: playlist['title'] ?? '',
                        imageUrl: thumb,
                        onTap: () {
                          // TODO: open local playlist
                        },
                      );
                    }).toList(),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: _ytRecommendations.take(5).map((item) {
                      return PlaylistCard(
                        title: item['title'] ?? '',
                        imageUrl: item['thumbnail'] ?? '',
                        onTap: () {
                          // TODO: Play YouTube song
                        },
                      );
                    }).toList(),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 30),
            const SectionTitle(title: "🎧 Explore Playlists"),

            SizedBox(
              height: 160,
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: _playlists.map((playlist) {
                  final first = playlist['songs'].isNotEmpty ? playlist['songs'][0] : null;
                  final thumb = first != null ? first['thumbnail'] ?? '' : '';
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
