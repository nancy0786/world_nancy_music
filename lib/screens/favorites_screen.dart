cat > lib/screens/favorites_screen.dart << 'EOF'
import 'package:flutter/material.dart';
import 'package:world_music_nancy/services/storage_service.dart';
import 'package:world_music_nancy/widgets/thumbnail.dart';
import 'player_screen.dart';

class FavoritesScreen extends StatefulWidget {
  const FavoritesScreen({super.key});

  @override
  State<FavoritesScreen> createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends State<FavoritesScreen> {
  List<Map<String, String>> _favorites = [];

  @override
  void initState() {
    super.initState();
    _loadFavorites();
  }

  void _loadFavorites() async {
    final saved = await StorageService.getFavoriteSongs();
    setState(() {
      _favorites = saved;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.pinkAccent,
        title: const Text('Favorites'),
      ),
      body: ListView.builder(
        itemCount: _favorites.length,
        itemBuilder: (context, index) {
          final song = _favorites[index];
          return ListTile(
            leading: YouTubeThumbnail(videoId: Uri.parse(song['url']!).queryParameters['v'] ?? ''),
            title: Text(song['title'] ?? '', style: const TextStyle(color: Colors.white)),
            subtitle: Text(song['channel'] ?? '', style: const TextStyle(color: Colors.white70)),
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
          );
        },
      ),
    );
  }
}
EOF
