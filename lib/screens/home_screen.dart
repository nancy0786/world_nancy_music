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

    final searchStream = await _yt.search.getVideos(query);
    final results = await searchStream.toList();
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
      appBar: AppBar(
        title: const Text('Nancy Music World'),
        backgroundColor: Colors.black,
        actions: [
          IconButton(
            icon: const Icon(Icons.favorite),
            onPressed: () => print("Go to favorites screen"),
          ),
        ],
      ),
      backgroundColor: Colors.black,
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12),
            child: TextField(
              controller: _searchController,
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                hintText: 'Search YouTube...',
                hintStyle: const TextStyle(color: Colors.white70),
                filled: true,
                fillColor: Colors.grey[900],
                suffixIcon: IconButton(
                  icon: const Icon(Icons.search, color: Colors.white),
                  onPressed: _searchSongs,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onSubmitted: (_) => _searchSongs(),
            ),
          ),
          Expanded(
            child: _results.isEmpty
                ? const Center(child: Text("No results yet", style: TextStyle(color: Colors.white)))
                : ListView.builder(
                    itemCount: _results.length,
                    itemBuilder: (context, index) {
                      final video = _results[index];
                      return ListTile(
                        leading: YouTubeThumbnail(videoId: video.id.value),
                        title: Text(video.title, style: const TextStyle(color: Colors.white)),
                        subtitle: Text(video.author, style: const TextStyle(color: Colors.white70)),
                        trailing: IconButton(
                          icon: const Icon(Icons.favorite_border, color: Colors.white),
                          onPressed: () => _addToFavorites(video),
                        ),
                        onTap: () => _playSong(video),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
