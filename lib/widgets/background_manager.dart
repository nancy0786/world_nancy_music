import 'dart:math';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class BackgroundManager extends StatefulWidget {
  final Widget child;

  const BackgroundManager({super.key, required this.child});

  @override
  State<BackgroundManager> createState() => _BackgroundManagerState();
}

class _BackgroundManagerState extends State<BackgroundManager> {
  late final String _selectedBackground;
  VideoPlayerController? _videoController;

  final List<String> _backgrounds = [
    // Cyberpunk: mp4
    for (int i = 1; i <= 18; i++) 'assets/backgrounds/cyberpunk/cyber$i.mp4',
    // Cyberpunk: jpg
    for (int i = 19; i <= 30; i++) 'assets/backgrounds/cyberpunk/cyber$i.jpg',

    // Girls: jpg
    for (int i = 1; i <= 14; i++) 'assets/backgrounds/girls/girl$i.jpg',
    // Girls: mp4
    for (int i = 15; i <= 30; i++) 'assets/backgrounds/girls/girl$i.mp4',

    // Nature: mp4
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
          _videoController!.play();
          setState(() {});
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
    return Stack(
      children: [
        Positioned.fill(
          child: _selectedBackground.endsWith('.mp4')
              ? (_videoController != null && _videoController!.value.isInitialized)
                  ? VideoPlayer(_videoController!)
                  : const SizedBox()
              : Image.asset(_selectedBackground, fit: BoxFit.cover),
        ),
        Positioned.fill(
          child: Container(color: Colors.black.withOpacity(0.4)),
        ),
        widget.child,
      ],
    );
  }
}
