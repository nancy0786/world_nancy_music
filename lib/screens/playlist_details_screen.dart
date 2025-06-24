import 'dart:io';
import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';
import 'package:world_music_nancy/components/base_screen.dart';
import 'package:world_music_nancy/widgets/neon_aware_tile.dart';
import 'package:world_music_nancy/screens/player_screen.dart';
import 'package:world_music_nancy/services/ytdlp_service.dart'; // ✅ updated
import 'package:world_music_nancy/services/storage_service.dart';
import 'package:world_music_nancy/widgets/mini_player_bar.dart';

class PlaylistDetailsScreen extends StatefulWidget {
  final String playlistName;
  final String imagePath;
  final String visibility;
  final String? youtubePlaylistId;

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
  List<Map<String, String>> _removedSongs = [];

  @override
  void initState() {
    super.initState();
    _loadSongs();
  }

  Future<void> _loadSongs() async {
    if (widget.youtubePlaylistId != null) {
      final ytSongs = await YtDlpService.getSongsFromPlaylist(widget.youtubePlaylistId!); // ✅ updated
      setState(() => _songs = ytSongs);
    } else {
      final allPlaylists = await StorageService.getPlaylists();
      final matched = allPlaylists.firstWhere(
        (p) => p['title'] == widget.playlistName,
        orElse: () => {},
      );

      final localSongs = (matched['songs'] ?? []) as List<dynamic>;
      setState(() {
        _songs = localSongs.map((e) {
          final song = Map<String, String>.from(e);
          return {
            'title': song['title'] ?? '',
            'thumbnail': song['thumbnail'] ?? '',
            'channel': song['channel'] ?? '',
            'url': song['url'] ?? '',
            'videoId': song['videoId'] ?? '',
          };
        }).toList();
      });
    }
  }

  void _deleteSong(int index) {
    final removed = _songs.removeAt(index);
    _removedSongs.add(removed);
    setState(() {});
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('🗑️ Song removed'),
        duration: const Duration(seconds: 5),
        action: SnackBarAction(
          label: 'Undo',
          onPressed: () {
            setState(() {
              _songs.insert(index, removed);
              _removedSongs.remove(removed);
            });
          },
        ),
      ),
    );
  }

  void _sharePlaylist() {
    final link = 'nancymusic://playlist?name=${Uri.encodeComponent(widget.playlistName)}';
    final message = '''
🎵 Check out my playlist on Nancy Music World: ${widget.playlistName}
Open in app: $link
''';
    Share.share(message);
  }

  void _playAll() {
    if (_songs.isEmpty) return;
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => PlayerScreen(
          title: _songs[0]['title']!,
          author: _songs[0]['channel']!,
          url: _songs[0]['url']!,
          queue: _songs,
        ),
      ),
    );
  }

  Future<void> _downloadAll() async {
    for (var song in _songs) {
      if (song['videoId'] != null) {
        final data = await YtDlpService.getAudioStream(song['videoId']!); // ✅ updated
        if (data != null && data['url'] != null && data['title'] != null) {
          await StorageService.downloadAudio(data['url']!, data['title']!);
        }
      }
    }
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("⬇ All songs are being downloaded")),
    );
  }

  String _getDurationText() {
    return "${_songs.length} song${_songs.length == 1 ? '' : 's'}";
  }

  @override
  Widget build(BuildContext context) {
    return BaseScreen(
      child: Scaffold(
        appBar: AppBar(
          title: Text(widget.playlistName),
          backgroundColor: Colors.black,
          actions: [
            IconButton(icon: const Icon(Icons.play_arrow), onPressed: _playAll),
            IconButton(icon: const Icon(Icons.download), onPressed: _downloadAll),
            IconButton(icon: const Icon(Icons.share), onPressed: _sharePlaylist),
          ],
        ),
        backgroundColor: Colors.transparent,
        body: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.only(bottom: 80),
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    if (widget.imagePath.isNotEmpty && File(widget.imagePath).existsSync())
                      ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Image.file(
                          File(widget.imagePath),
                          height: 140,
                          width: double.infinity,
                          fit: BoxFit.cover,
                        ),
                      )
                    else
                      Container(
                        height: 140,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: Colors.grey[900],
                          borderRadius: BorderRadius.circular(12),
                        ),
                        alignment: Alignment.center,
                        child: const Icon(Icons.music_note, color: Colors.white70, size: 50),
                      ),
                    const SizedBox(height: 12),
                    Text(
                      _getDurationText(),
                      style: const TextStyle(color: Colors.white70, fontSize: 14),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      "Visibility: ${widget.visibility.toUpperCase()}",
                      style: const TextStyle(color: Colors.white70, fontSize: 16),
                    ),
                    const SizedBox(height: 24),
                    _songs.isEmpty
                        ? const Center(child: CircularProgressIndicator(color: Colors.cyanAccent))
                        : ListView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
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
                                trailing: IconButton(
                                  icon: const Icon(Icons.delete, color: Colors.redAccent),
                                  onPressed: () => _deleteSong(i),
                                ),
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) => PlayerScreen(
                                        title: song['title']!,
                                        author: song['channel']!,
                                        url: song['url']!,
                                      ),
                                    ),
                                  );
                                },
                              );
                            },
                          ),
                  ],
                ),
              ),
            ),
            const Align(
              alignment: Alignment.bottomCenter,
              child: MiniPlayerBar(),
            ),
          ],
        ),
      ),
    );
  }
}
