import 'package:flutter/material.dart';
import 'package:world_music_nancy/components/base_screen.dart';
import 'package:just_audio/just_audio.dart';
import 'package:world_music_nancy/components/base_screen.dart';

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
