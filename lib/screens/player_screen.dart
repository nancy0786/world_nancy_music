import 'package:flutter/material.dart';
import 'package:world_music_nancy/components/base_screen.dart';
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
  bool _isPlaying = false;

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

  void _togglePlayback() async {
    if (_player.playing) {
      await _player.pause();
    } else {
      await _player.play();
    }
    setState(() {
      _isPlaying = _player.playing;
    });
  }

  @override
  Widget build(BuildContext context) {
    return BaseScreen(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          title: Text(widget.title),
          backgroundColor: Colors.black,
        ),
        body: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                _isPlaying ? Icons.pause_circle_filled : Icons.play_circle_fill,
                size: 100,
                color: Colors.cyanAccent,
              ),
              const SizedBox(height: 20),
              Text(
                widget.title,
                style: const TextStyle(color: Colors.white, fontSize: 24),
              ),
              const SizedBox(height: 10),
              Text(
                widget.author,
                style: const TextStyle(color: Colors.white70, fontSize: 18),
              ),
              const SizedBox(height: 30),
              ElevatedButton(
                onPressed: _togglePlayback,
                child: Text(_isPlaying ? 'Pause' : 'Play'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
