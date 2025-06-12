import 'package:flutter/material.dart';
import 'package:youtube_explode_dart/youtube_explode_dart.dart';
import 'package:world_music_nancy/services/storage_service.dart';
import 'package:world_music_nancy/widgets/thumbnail.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _searchController = TextEditingController();
  final YoutubeExplode _yt = YoutubeExplode();
  List<Video> _results = [];
  Video? _currentVideo;
  List<Map<String, String>> _favorites = [];

  @override
  void initState() {
    super.initState();
    _loadFavorites();
  }

  Future<void> _loadFavorites() async {
    final saved = await StorageService.getFavoriteSongs();
    setState(() => _favorites = saved);
  }

  Future<void> _searchSongs() async {
    final query = _searchController.text.trim();
    if (query.isEmpty) return;

    final results = await _yt.search.getVideos(query).toList();
    setState(() => _results = results.take(10).toList());
  }

  Future<void> _playSong(Video video) async {
    final songInfo = {
      'title': video.title,
      'url': 'https://youtube.com/watch?v=${video.id.value}',
      'channel': video.author,
      'duration': video.duration?.inSeconds.toString() ?? '0',
      'id': video.id.value,
    };
    setState(() => _currentVideo = video);
    await StorageService.saveLastPlayed(songInfo);
  }

  void _addToFavorites(Video video) {
    final videoId = video.id.value;
    if (_favorites.any((fav) => fav['id'] == videoId)) return;

    final favMap = {
      'title': video.title,
      'url': 'https://youtube.com/watch?v=$videoId',
      'channel': video.author,
      'duration': video.duration?.inSeconds.toString() ?? '0',
      'id': videoId,
    };

    setState(() => _favorites.add(favMap));
    StorageService.saveFavoriteSongs(_favorites);
  }

  @override
  void dispose() {
    _yt.close();
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text("Nancy Music World"),
        backgroundColor: Colors.deepPurple.shade900,
        actions: const [Icon(Icons.settings)],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            if (_currentVideo != null) ...[
              Text("Now Playing: ${_currentVideo!.title}", style: const TextStyle(color: Colors.white)),
              const SizedBox(height: 10),
            ],
            TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: "Search YouTube...",
                filled: true,
                fillColor: Colors.grey.shade900,
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                suffixIcon: IconButton(icon: const Icon(Icons.search), onPressed: _searchSongs),
              ),
              style: const TextStyle(color: Colors.white),
            ),
            const SizedBox(height: 20),
            if (_results.isNotEmpty) ...[
              const Text("Results", style: TextStyle(color: Colors.cyanAccent, fontSize: 18)),
              for (var v in _results)
                ListTile(
                  leading: YouTubeThumbnail(videoId: v.id.value),
                  title: Text(v.title, style: const TextStyle(color: Colors.white)),
                  subtitle: Text(v.author, style: const TextStyle(color: Colors.white70)),
                  trailing: IconButton(
                    icon: const Icon(Icons.favorite_border),
                    onPressed: () => _addToFavorites(v),
                  ),
                  onTap: () => _playSong(v),
                ),
            ],
            const SizedBox(height: 20),
            if (_favorites.isNotEmpty) ...[
              const Text("❤️ Favorites", style: TextStyle(color: Colors.pinkAccent, fontSize: 18)),
              for (var f in _favorites)
                ListTile(
                  leading: YouTubeThumbnail(videoId: f['id']!),
                  title: Text(f['title']!, style: const TextStyle(color: Colors.white)),
                  subtitle: Text(f['channel']!, style: const TextStyle(color: Colors.white70)),
                  onTap: () {
                    // Simply show in UI instead of constructing internal class
                    showDialog(
                      context: context,
                      builder: (_) => AlertDialog(
                        title: Text(f['title']!),
                        content: Text("By ${f['channel']} • ${f['duration']} sec"),
                        backgroundColor: Colors.black,
                        titleTextStyle: const TextStyle(color: Colors.white),
                        contentTextStyle: const TextStyle(color: Colors.white70),
                      ),
                    );
                  },
                ),
            ],
          ],
        ),
      ),
    );
  }
}
