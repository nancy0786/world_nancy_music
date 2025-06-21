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
import 'package:world_music_nancy/screens/player_screen.dart';

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
  List<Map<String, String>> _topSongs = [];

  @override
  void initState() {
    super.initState();
    _loadData();
    _loadLastPlayed();
    _loadRecommendations();
    _loadTopSongs();
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
      _playlists = List<Map<String, dynamic>>.from(customPlaylists);
    });
  }

  Future<void> _loadLastPlayed() async {
    final data = await StorageService.getLastPlayed();
    setState(() => _lastPlayed = Map<String, String>.from(data ?? {}));
  }

  Future<void> _loadRecommendations() async {
    final ytRecs = await YouTubeService.getMusicPlaylists();
    setState(() => _ytRecommendations = ytRecs);
  }

  Future<void> _loadTopSongs() async {
    final trending = await YouTubeService.search("top trending music india");
    setState(() => _topSongs = trending.take(20).toList());
  }

  void _openPlaylist(Map<String, dynamic> playlist) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => PlaylistDetailsScreen(
          playlistName: playlist['title'] ?? '',
          imagePath: '',
          visibility: playlist['visibility'] ?? 'private',
        ),
      ),
    );
  }

  void _openYTPlaylist(Map<String, String> playlist) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => PlaylistDetailsScreen(
          playlistName: playlist['title'] ?? '',
          imagePath: '',
          visibility: 'public',
          youtubePlaylistId: playlist['playlistId'],
        ),
      ),
    );
  }

  Widget _buildTopSongsGrid() {
    return GridView.builder(
      itemCount: _topSongs.length,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 4,
        crossAxisSpacing: 8,
        mainAxisSpacing: 8,
        childAspectRatio: 0.7,
      ),
      itemBuilder: (_, i) {
        final song = _topSongs[i];
        return GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => PlayerScreen(
                  title: song['title'] ?? '',
                  author: song['channel'] ?? '',
                  url: song['url'] ?? '',
                ),
              ),
            );
          },
          child: Column(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.network(
                  song['thumbnail'] ?? '',
                  width: 70,
                  height: 70,
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                song['title'] ?? '',
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(color: Colors.white70, fontSize: 12),
              ),
            ],
          ),
        );
      },
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
            '🎧 Nancy Music World',
            style: TextStyle(
              fontSize: 26,
              fontWeight: FontWeight.bold,
              color: Colors.cyanAccent,
              fontFamily: 'Orbitron',
              shadows: [Shadow(blurRadius: 6, color: Colors.pinkAccent)],
            ),
          ),
        ),
        body: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            if (_recentlyPlayed.isNotEmpty) ...[
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
                      subtitle: Text(song.artist ?? '', style: const TextStyle(color: Colors.white70)),
                      leading: Image.network(song.thumbnailUrl ?? '', width: 50, height: 50),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => PlayerScreen(
                              title: song.title,
                              author: song.artist ?? '',
                              url: song.url ?? '',
                            ),
                          ),
                        );
                      },
                    );
                  }).toList(),
                ),
              ),
              const SizedBox(height: 24),
            ],

            const SectionTitle(title: "🔥 Top Music"),
            _buildTopSongsGrid(),
            const SizedBox(height: 24),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: const [
                SectionTitle(title: "Recommended"),
                Text("View All", style: TextStyle(color: Colors.cyanAccent)),
              ],
            ),
            SizedBox(
              height: 140,
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: _ytRecommendations.map((item) {
                  return PlaylistCard(
                    title: item['title'] ?? '',
                    imageUrl: item['thumbnail'] ?? '',
                    onTap: () => _openYTPlaylist(item),
                  );
                }).toList(),
              ),
            ),

            const SizedBox(height: 30),
            const SectionTitle(title: "🎧 Explore Playlists"),
            SizedBox(
              height: 160,
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: _playlists.map((playlist) {
                  final songs = List<Map<String, dynamic>>.from(playlist['songs'] ?? []);
                  final first = songs.isNotEmpty ? songs[0] : null;
                  final thumb = first != null ? first['thumbnail'] ?? '' : '';
                  return PlaylistCard(
                    title: playlist['title'] ?? '',
                    imageUrl: thumb,
                    onTap: () => _openPlaylist(playlist),
                  );
                }).toList(),
              ),
            ),
            const SizedBox(height: 100), // Space for mini player
          ],
        ),
        bottomNavigationBar: _lastPlayed != null
            ? GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => PlayerScreen(
                        title: _lastPlayed!['title']!,
                        author: _lastPlayed!['channel']!,
                        url: _lastPlayed!['url']!,
                      ),
                    ),
                  );
                },
                child: Container(
                  color: Colors.black87,
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  child: Row(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(6),
                        child: Image.network(
                          _lastPlayed!['thumbnail'] ?? '',
                          width: 50,
                          height: 50,
                          fit: BoxFit.cover,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          _lastPlayed!['title'] ?? '',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(color: Colors.white),
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.pause_circle_filled, color: Colors.white),
                        onPressed: () {
                          // toggle play/pause
                        },
                      ),
                    ],
                  ),
                ),
              )
            : null,
      ),
    );
  }
}
