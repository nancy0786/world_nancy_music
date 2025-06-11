import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';

class PlayerScreen extends StatefulWidget {
  final String title;
  final String author;
  final String url;

  const PlayerScreen({
    super.key,
    required this.title,
    required this.author,
    required this.url,
  });

  @override
  State<PlayerScreen> createState() => _PlayerScreenState();
}

class _PlayerScreenState extends State<PlayerScreen> {
  late AudioPlayer _player;

  @override
  void initState() {
    super.initState();
    _player = AudioPlayer();
    _initPlayer();
  }

  Future<void> _initPlayer() async {
    try {
      await _player.setUrl(widget.url);
    } catch (e) {
      debugPrint("Failed to load audio: $e");
    }
  }

  @override
  void dispose() {
    _player.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.deepPurple,
        title: const Text('Now Playing'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.music_note, size: 100, color: Colors.purpleAccent),
          const SizedBox(height: 20),
          Text(widget.title,
              style: const TextStyle(fontSize: 20, color: Colors.white)),
          const SizedBox(height: 8),
          Text(widget.author, style: const TextStyle(color: Colors.white70)),
          const SizedBox(height: 30),
          StreamBuilder<PlayerState>(
            stream: _player.playerStateStream,
            builder: (context, snapshot) {
              final state = snapshot.data;
              final playing = state?.playing ?? false;

              return IconButton(
                iconSize: 60,
                icon: Icon(playing ? Icons.pause_circle : Icons.play_circle),
                color: Colors.pinkAccent,
                onPressed: () {
                  if (playing) {
                    _player.pause();
                  } else {
                    _player.play();
                  }
                },
              );
            },
          ),
        ],
      ),
    );
  }
}
