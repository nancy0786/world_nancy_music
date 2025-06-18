import 'package:world_music_nancy/widgets/neon_aware_button.dart';
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:world_music_nancy/services/youtube_service.dart';
import 'package:world_music_nancy/services/storage_service.dart';
import 'package:world_music_nancy/services/queue_service.dart';
import 'queue_sheet.dart';
import 'lyrics_display.dart';

class PlayerControls extends StatefulWidget {
  const PlayerControls({super.key});

  @override
  State<PlayerControls> createState() => _PlayerControlsState();
}

class _PlayerControlsState extends State<PlayerControls> {
  final AudioPlayer _player = AudioPlayer();
  String _title = 'No Song Playing';
  String _thumbnail = 'assets/thumbnails/default-thumbnail.jpg';
  final queue = QueueService();

  final List<Map<String, dynamic>> sampleLyrics = [
    {"time": 1, "line": "🎵 Just a small town girl"},
    {"time": 4, "line": "Living in a lonely world"},
    {"time": 7, "line": "She took the midnight train going anywhere"},
    {"time": 12, "line": "🎶 Just a city boy"},
    {"time": 15, "line": "Born and raised in South Detroit"},
    {"time": 18, "line": "He took the midnight train going anywhere"},
  ];

  @override
  void initState() {
    super.initState();
    _loadLastPlayed();
  }

  Future<void> _loadLastPlayed() async {
    try {
      final last = await StorageService.getLastPlayed();
      if (last != null && last['url'] != null) {
        setState(() {
          _title = last['title'] ?? 'Unknown Title';
          _thumbnail = last['thumbnail'] ?? 'assets/thumbnails/default-thumbnail.jpg';
        });
        await _player.setUrl(last['url']);
      }
    } catch (e) {
      debugPrint('Failed to load last played song: $e');
    }
  }

  Future<void> _playSong(String videoId) async {
    try {
      final song = await YouTubeService.getAudioStream(videoId);
      if (song != null && song['url'] != null) {
        await _player.setUrl(song['url']);
        await StorageService.saveLastPlayed(song);
        setState(() {
          _title = song['title'] ?? 'Unknown Title';
          _thumbnail = song['thumbnail'] ?? 'assets/thumbnails/default-thumbnail.jpg';
        });
        _player.play();
      }
    } catch (e) {
      debugPrint('Error playing song: $e');
    }
  }

  @override
  void dispose() {
    _player.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final String? currentSong = queue.currentSong;

    return Column(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: _thumbnail.startsWith('http')
              ? Image.network(
                  _thumbnail,
                  width: 220,
                  height: 220,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) =>
                      const Icon(Icons.broken_image, size: 80, color: Colors.red),
                )
              : Image.asset(
                  _thumbnail,
                  width: 220,
                  height: 220,
                  fit: BoxFit.cover,
                ),
        ),
        const SizedBox(height: 10),
        Text(
          currentSong != null ? 'Now Playing: $currentSong' : _title,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.tealAccent,
            shadows: [
              Shadow(
                blurRadius: 10,
                color: Colors.cyanAccent,
                offset: Offset(1, 1),
              )
            ],
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 10),
        LyricsDisplay(syncedLyrics: sampleLyrics),
        const SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            IconButton(
              icon: const Icon(Icons.skip_previous, color: Colors.white),
              onPressed: () => queue.skipPrevious(),
            ),
            IconButton(
              icon: const Icon(Icons.play_arrow, color: Colors.tealAccent),
              iconSize: 32,
              onPressed: () => _player.play(),
            ),
            IconButton(
              icon: const Icon(Icons.pause, color: Colors.cyanAccent),
              iconSize: 28,
              onPressed: () => _player.pause(),
            ),
            IconButton(
              icon: const Icon(Icons.skip_next, color: Colors.white),
              onPressed: () => queue.skipNext(),
            ),
          ],
        ),
        const SizedBox(height: 10),
        NeonAwareButton(
          onTap: () {
            showModalBottomSheet(
              context: context,
              backgroundColor: Colors.black87,
              isScrollControlled: true,
              builder: (context) => const QueueSheet(),
            );
          },
          icon: const Icon(Icons.queue_music),
          label: const Text("Show Queue"),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.deepPurpleAccent,
            foregroundColor: Colors.white,
            shape: const StadiumBorder(),
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            textStyle: const TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
      ],
    );
  }
}
