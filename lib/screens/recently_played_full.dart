import 'package:flutter/material.dart';
import 'package:world_music_nancy/models/song_model.dart';
import 'package:world_music_nancy/services/storage_service.dart';
import 'package:world_music_nancy/widgets/neon_aware_tile.dart';

class RecentlyPlayedFullPage extends StatefulWidget {
  const RecentlyPlayedFullPage({super.key});

  @override
  State<RecentlyPlayedFullPage> createState() => _RecentlyPlayedFullPageState();
}

class _RecentlyPlayedFullPageState extends State<RecentlyPlayedFullPage> {
  List<SongModel> _songs = [];
  String _search = '';

  @override
  void initState() {
    super.initState();
    _loadSongs();
  }

  Future<void> _loadSongs() async {
    final recents = await StorageService.getHistory();
    setState(() {
      _songs = recents.reversed.map((e) => SongModel(
        title: e['title'] ?? '',
        artist: e['channel'] ?? '',
        thumbnailUrl: e['thumbnail'] ?? '',
        url: e['url'] ?? '',
        id: e['id'] ?? '',
        channel: e['channel'] ?? '',
      )).toList();
    });
  }

  void _removeSong(SongModel song) async {
    setState(() => _songs.remove(song));
    await StorageService.removeFromHistory(song.id ?? '');

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text("❌ Removed '${song.title}' from history"),
        duration: const Duration(seconds: 5),
        action: SnackBarAction(
          label: 'Undo',
          textColor: Colors.cyanAccent,
          onPressed: () async {
            await StorageService.addToHistory(song.toMap());
            _loadSongs();
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final filtered = _songs.where((s) => s.title.toLowerCase().contains(_search.toLowerCase())).toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text("🕘 Recently Played", style: TextStyle(color: Colors.cyanAccent)),
        backgroundColor: Colors.black,
      ),
      backgroundColor: Colors.black,
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12),
            child: TextField(
              style: const TextStyle(color: Colors.white),
              decoration: const InputDecoration(
                hintText: "Search...",
                hintStyle: TextStyle(color: Colors.white38),
                prefixIcon: Icon(Icons.search, color: Colors.cyanAccent),
                filled: true,
                fillColor: Colors.white12,
                border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(12))),
              ),
              onChanged: (val) => setState(() => _search = val),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: filtered.length,
              itemBuilder: (context, index) {
                final song = filtered[index];
                return Dismissible(
                  key: Key(song.id ?? song.title),
                  direction: DismissDirection.endToStart,
                  background: Container(
                    color: Colors.redAccent,
                    alignment: Alignment.centerRight,
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: const Icon(Icons.delete, color: Colors.white),
                  ),
                  onDismissed: (_) => _removeSong(song),
                  child: NeonAwareTile(
                    title: Text(song.title, style: const TextStyle(color: Colors.white)),
                    subtitle: Text(song.artist, style: const TextStyle(color: Colors.white54)),
                    leading: Image.network(song.thumbnailUrl ?? '', width: 50, height: 50),
                    onTap: () {
                      // TODO: play song
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
