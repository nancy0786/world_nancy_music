mkdir -p lib/widgets && cat > lib/widgets/song_player.dart << 'EOF'
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';

class SongPlayer extends StatefulWidget {
  final String url;

  const SongPlayer({super.key, required this.url});

  @override
  State<SongPlayer> createState() => _SongPlayerState();
}

class _SongPlayerState extends State<SongPlayer> {
  final AudioPlayer _player = AudioPlayer();
  bool _isPlaying = false;

  @override
  void initState() {
    super.initState();
    _setupPlayer();
  }

  Future<void> _setupPlayer() async {
    try {
      await _player.setUrl(widget.url);
    } catch (e) {
      debugPrint("Error loading audio: $e");
    }
  }

  void _togglePlayPause() {
    if (_player.playing) {
      _player.pause();
      setState(() => _isPlaying = false);
    } else {
      _player.play();
      setState(() => _isPlaying = true);
    }
  }

  @override
  void dispose() {
    _player.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        IconButton(
          icon: Icon(_isPlaying ? Icons.pause : Icons.play_arrow),
          onPressed: _togglePlayPause,
        ),
        const Text('Preview Song', style: TextStyle(color: Colors.white)),
      ],
    );
  }
}
EOF
