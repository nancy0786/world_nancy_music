import 'package:world_music_nancy/widgets/neon_aware_tile.dart';
import 'package:world_music_nancy/widgets/neon_aware_tile.dart';
import 'package:world_music_nancy/widgets/neon_aware_container.dart';
import 'package:flutter/material.dart';
import 'package:world_music_nancy/components/base_screen.dart';
import 'package:world_music_nancy/services/storage_service.dart';
import 'package:world_music_nancy/widgets/youtube_thumbnail.dart';

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

  Future<void> _loadFavorites() async {
    final favs = await StorageService.getFavoriteSongs();
    setState(() => _favorites = favs);
  }

  void _removeFavorite(int index) {
    final removedSong = _favorites[index];
    setState(() => _favorites.removeAt(index));
    StorageService.saveFavoriteSongs(_favorites);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text("Removed from favorites: ${removedSong['title']}"),
        action: SnackBarAction(
          label: 'UNDO',
          textColor: Colors.cyanAccent,
          onPressed: () {
            setState(() => _favorites.insert(index, removedSong));
            StorageService.saveFavoriteSongs(_favorites);
          },
        ),
        duration: const Duration(seconds: 5),
        backgroundColor: Colors.black87,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BaseScreen(
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Your Favorite Songs"),
          backgroundColor: Colors.black,
          centerTitle: true,
        ),
        backgroundColor: Colors.transparent,
        body: _favorites.isEmpty
            ? const Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.favorite_border, size: 80, color: Colors.grey),
                    SizedBox(height: 20),
                    Text(
                      "No favorites yet.",
                      style: TextStyle(fontSize: 18, color: Colors.grey),
                    ),
                  ],
                ),
              )
            : ListView.builder(
                padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
                itemCount: _favorites.length,
                itemBuilder: (context, index) {
                  final song = _favorites[index];
                  return Dismissible(
                    key: Key(song['id'] ?? '$index'),
                    direction: DismissDirection.endToStart,
                    background: NeonAwareContainer(
                      padding: const EdgeInsets.only(right: 20),
                      alignment: Alignment.centerRight,
                      color: Colors.redAccent,
                      child: const Icon(Icons.delete, color: Colors.white, size: 28),
                    ),
                    onDismissed: (_) => _removeFavorite(index),
                    child: NeonAwareTile(
                      contentPadding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                      leading: YouTubeThumbnail(videoId: song['id'] ?? ''),
                      title: Text(
                        song['title'] ?? '',
                        style: const TextStyle(color: Colors.white),
                      ),
                      subtitle: Text(
                        song['channel'] ?? '',
                        style: const TextStyle(color: Colors.white70),
                      ),
                      onTap: () {
                        // TODO: Play or show song screen
                      },
                    ),
                  );
                },
              ),
      ),
    );
  }
}
