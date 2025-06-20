import 'dart:io';
import 'package:flutter/material.dart';
import 'package:world_music_nancy/components/base_screen.dart';
import 'package:world_music_nancy/widgets/neon_aware_tile.dart';
import 'package:world_music_nancy/screens/player_screen.dart';
import 'package:world_music_nancy/services/youtube_service.dart';
import 'package:world_music_nancy/services/storage_service.dart';

class PlaylistDetailsScreen extends StatefulWidget {
  final String playlistName;
  final String imagePath;
  final String visibility;
  final String? youtubePlaylistId; // Optional YouTube playlist support

  const PlaylistDetailsScreen({
    super.key,
    required this.playlistName,
    required this.imagePath,
    required this.visibility,
    this.youtubePlaylistId,
  });

  @override
  State<PlaylistDetailsScreen> createState() => _PlaylistDetailsScreenState();
}

class _PlaylistDetailsScreenState extends State<PlaylistDetailsScreen> {
  List<Map<String, String>> _songs = [];

  @override
  void initState() {
    super.initState();
    _loadSongs();
  }

  Future<void> _loadSongs() async {
    if (widget.youtubePlaylistId != null) {
      final ytSongs = await YouTubeService.getSongsFromPlaylist(widget.youtubePlaylistId!);
      setState(() => _songs = ytSongs);
    } else {
      final allPlaylists = await StorageService.getPlaylists();
      final matched = allPlaylists.firstWhere(
        (p) => p['title'] == widget.playlistName,
        orElse: () => {},
      );

      final localSongs = (matched['songs'] ?? []) as List<dynamic>;
      setState(() {
        _songs = localSongs.map((e) => {
          'title': e['title'] ?? '',
          'thumbnail': e['thumbnail'] ?? '',
          'channel': e['channel'] ?? '',
          'url': e['url'] ?? '',
        }).toList();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return BaseScreen(
      child: Scaffold(
        appBar: AppBar(
          title: Text(widget.playlistName),
          backgroundColor: Colors.black,
        ),
        backgroundColor: Colors.transparent,
        body: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              if (widget.imagePath.isNotEmpty && File(widget.imagePath).existsSync())
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.file(File(widget.imagePath), height: 200, fit: BoxFit.cover),
                )
              else
                Container(
                  height: 200,
                  decoration: BoxDecoration(
                    color: Colors.grey[900],
                    borderRadius: BorderRadius.circular(12),
                  ),
                  alignment: Alignment.center,
                  child: const Icon(Icons.music_note, color: Colors.white70, size: 60),
                ),
              const SizedBox(height: 16),
              Text(
                "Visibility: ${widget.visibility.toUpperCase()}",
                style: const TextStyle(color: Colors.white70, fontSize: 16),
              ),
              const SizedBox(height: 24),
              Expanded(
                child: _songs.isEmpty
                    ? const Center(child: CircularProgressIndicator(color: Colors.cyanAccent))
                    : ListView.builder(
                        itemCount: _songs.length,
                        itemBuilder: (_, i) {
                          final song = _songs[i];
                          return NeonAwareTile(
                            leading: Image.network(
                              song['thumbnail'] ?? '',
                              width: 60,
                              height: 60,
                              fit: BoxFit.cover,
                            ),
                            title: Text(song['title'] ?? '', style: const TextStyle(color: Colors.white)),
                            subtitle: Text(song['channel'] ?? '', style: const TextStyle(color: Colors.white70)),
                            onTap: () {
                              Navigator.push(context, MaterialPageRoute(
                                builder: (_) => PlayerScreen(
                                  title: song['title']!,
                                  author: song['channel']!,
                                  url: song['url']!,
                                ),
                              ));
                            },
                          );
                        },
                      ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
