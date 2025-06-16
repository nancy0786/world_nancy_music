import 'package:flutter/material.dart';
import 'package:world_music_nancy/components/base_screen.dart';
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
    return BaseScreen(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: CustomAppBar(title: 'Search Songs'),
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(12),
              child: TextField(
                controller: _controller,
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  hintText: 'Search YouTube...',
                  hintStyle: const TextStyle(color: Colors.white54),
                  suffixIcon: IconButton(
                    icon: const Icon(Icons.search, color: Colors.white),
                    onPressed: () => _search(_controller.text),
                  ),
                  filled: true,
                  fillColor: Colors.black.withOpacity(0.6),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                ),
                onSubmitted: _search,
              ),
            ),
            if (_isLoading)
              const CircularProgressIndicator()
            else if (_results.isEmpty)
              const Text("No results yet", style: TextStyle(color: Colors.white))
            else
              Expanded(
                child: ListView.builder(
                  itemCount: _results.length,
                  itemBuilder: (context, index) {
                    final video = _results[index];
                    return ListTile(
                      title: Text(video['title'] ?? 'No Title', style: const TextStyle(color: Colors.white)),
                      subtitle: Text(video['channel'] ?? '', style: const TextStyle(color: Colors.white70)),
                      onTap: () => _play(video['id']!, video['title']!),
                    );
                  },
                ),
              ),
          ],
        ),
      ),
    );
  }
}
