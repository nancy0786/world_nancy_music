import 'dart:math';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class BackgroundManager extends StatefulWidget {
  const BackgroundManager({super.key});

  @override
  State<BackgroundManager> createState() => _BackgroundManagerState();
}

class _BackgroundManagerState extends State<BackgroundManager> {
  late final String _selectedBackground;
  VideoPlayerController? _videoController;

  final List<String> _backgrounds = [
    for (int i = 1; i <= 18; i++) 'assets/backgrounds/cyberpunk/cyber$i.mp4',
    for (int i = 19; i <= 30; i++) 'assets/backgrounds/cyberpunk/cyber$i.jpg',
    for (int i = 1; i <= 14; i++) 'assets/backgrounds/girls/girl$i.jpg',
    for (int i = 15; i <= 30; i++) 'assets/backgrounds/girls/girl$i.mp4',
    for (int i = 1; i <= 26; i++) 'assets/backgrounds/nature/nature$i.mp4',
  ];

  @override
  void initState() {
    super.initState();
    _selectedBackground = _backgrounds[Random().nextInt(_backgrounds.length)];

    if (_selectedBackground.endsWith('.mp4')) {
      _videoController = VideoPlayerController.asset(_selectedBackground)
        ..setLooping(true)
        ..initialize().then((_) {
          if (mounted) {
            _videoController!.play();
            setState(() {});
          }
        }).catchError((e) {
          debugPrint('Video failed to load: $e');
        });
    }
  }

  @override
  void dispose() {
    _videoController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isVideo = _selectedBackground.endsWith('.mp4');

    return Positioned.fill(
      child: Stack(
        children: [
          isVideo
              ? (_videoController != null && _videoController!.value.isInitialized)
                  ? VideoPlayer(_videoController!)
                  : const SizedBox()
              : Image.asset(
                  _selectedBackground,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => const ColoredBox(color: Colors.black),
                ),
          Container(color: Colors.black.withOpacity(0.4)), // dark overlay
        ],
      ),
    );
  }
}
