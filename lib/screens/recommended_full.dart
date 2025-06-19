import 'package:flutter/material.dart';
import 'package:world_music_nancy/widgets/playlist_card.dart';
import 'package:world_music_nancy/services/youtube_service.dart';

class RecommendedFullPage extends StatefulWidget {
  const RecommendedFullPage({super.key});

  @override
  State<RecommendedFullPage> createState() => _RecommendedFullPageState();
}

class _RecommendedFullPageState extends State<RecommendedFullPage> {
  List<Map<String, String>> _ytSongs = [];

  @override
  void initState() {
    super.initState();
    _fetch();
  }

  Future<void> _fetch() async {
    final data = await YouTubeService.getMusicPlaylists();
    setState(() => _ytSongs = data);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text("🎯 Recommended", style: TextStyle(color: Colors.cyanAccent)),
        backgroundColor: Colors.transparent,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh, color: Colors.pinkAccent),
            onPressed: _fetch,
          )
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Text("Recommended Playlists", style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 10),
          ..._ytSongs.map((item) => PlaylistCard(
                title: item['title'] ?? '',
                imageUrl: item['thumbnail'] ?? '',
                onTap: () {
                  // TODO: play or open playlist
                },
              )),
        ],
      ),
    );
  }
}
