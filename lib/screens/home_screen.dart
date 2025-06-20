import 'package:flutter/material.dart';
import 'package:world_music_nancy/widgets/neon_aware_tile.dart';
import 'package:world_music_nancy/widgets/section_title.dart';
import 'package:world_music_nancy/widgets/playlist_card.dart';
import 'package:world_music_nancy/services/storage_service.dart';
import 'package:world_music_nancy/services/youtube_service.dart';
import 'package:world_music_nancy/models/song_model.dart';
import 'package:world_music_nancy/components/base_screen.dart';
import 'package:world_music_nancy/widgets/now_playing_card.dart';
import 'package:world_music_nancy/screens/playlist_details_screen.dart';
import 'package:world_music_nancy/services/mood_service.dart';

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
  List<Map<String, String>> _moodSongs = [];

  @override
  void initState() {
    super.initState();
    _loadData();
    _loadLastPlayed();
    _loadRecommendations();
    _loadMoodSongs();
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

  Future<void> _loadMoodSongs() async {
    final mood = MoodService.getCurrentMood();
    final moodQueries = MoodService.getSongsForMood(mood);
    List<Map<String, String>> all = [];
    for (final query in moodQueries) {
      final result = await YouTubeService.search(query);
      all.addAll(result.take(3));
    }
    setState(() => _moodSongs = all);
  }

  void _openPlaylist(Map<String, dynamic> playlist) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => PlaylistDetailsScreen(
          playlistName: playlist['title'],
          imagePath: '',
          visibility: playlist['visibility'] ?? 'private',
        ),
      ),
    );
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
              fontFamily: 'DancingScript',
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

            /// 🔁 Recently Played
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
                  );
                }).toList(),
              ),
            ),

            const SizedBox(height: 24),

            /// 🧠 Mood-Based Playlist
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SectionTitle(title: "Mood: ${MoodService.getCurrentMood()}"),
                const Text("View All", style: TextStyle(color: Colors.cyanAccent)),
              ],
            ),
            SizedBox(
              height: 140,
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: _moodSongs.map((song) {
                  return PlaylistCard(
                    title: song['title'] ?? '',
                    imageUrl: song['thumbnail'] ?? '',
                    onTap: () {
                      // TODO: Play song
                    },
                  );
                }).toList(),
              ),
            ),

            const SizedBox(height: 24),

            /// 📺 YouTube Music Playlists
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
                        onTap: () => _openPlaylist(playlist),
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
                          // TODO: Play YouTube playlist
                        },
                      );
                    }).toList(),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 30),

            /// 🎧 Explore All Playlists
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
                    onTap: () => _openPlaylist(playlist),
                  );
                }).toList(),
              ),
            ),

            const SizedBox(height: 20),

            /// ▶️ Now Playing
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
