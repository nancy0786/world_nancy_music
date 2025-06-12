import 'package:flutter/material.dart';
import 'package:world_music_nancy/services/youtube_service.dart';
import 'package:world_music_nancy/screens/player_screen.dart';
import 'package:world_music_nancy/components/custom_app_bar.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _controller = TextEditingController();
  List<Map<String, String>> _results = [];
  bool _isLoading = false;

  Future<void> _search(String query) async {
    setState(() => _isLoading = true);
    final results = await YouTubeService.search(query);
    setState(() {
      _results = results;
      _isLoading = false;
    });
  }

  Future<void> _play(String videoId, String title) async {
    final data = await YouTubeService.getAudioStream(videoId);
    if (data == null) return;

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => PlayerScreen(
          title: data['title']!,
          author: 'YouTube',
          url: data['url']!,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.pinkAccent,
        title: const Text('Search Songs'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12),
            child: TextField(
              controller: _controller,
              onSubmitted: _search,
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                hintText: 'Search on YouTube...',
                hintStyle: const TextStyle(color: Colors.grey),
                suffixIcon: IconButton(
                  icon: const Icon(Icons.search, color: Colors.white),
                  onPressed: () => _search(_controller.text),
                ),
                filled: true,
                fillColor: Colors.grey[900],
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ),
          if (_isLoading)
            const Padding(
              padding: EdgeInsets.all(20),
              child: CircularProgressIndicator(color: Colors.pinkAccent),
            ),
          if (!_isLoading)
            Expanded(
              child: ListView.builder(
                itemCount: _results.length,
                itemBuilder: (context, index) {
                  final song = _results[index];
                  return ListTile(
                    leading: Image.network(song['thumbnail']!, width: 50),
                    title: Text(song['title']!,
                        style: const TextStyle(color: Colors.white)),
                    onTap: () => _play(song['videoId']!, song['title']!),
                  );
                },
              ),
            ),
        ],
      ),
    );
  }
}
