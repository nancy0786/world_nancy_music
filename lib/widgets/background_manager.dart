import 'dart:math';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:video_player/video_player.dart';
import 'package:world_music_nancy/providers/preferences_provider.dart';

class BackgroundManager extends StatefulWidget {
  const BackgroundManager({super.key});

  @override
  State<BackgroundManager> createState() => _BackgroundManagerState();
}

class _BackgroundManagerState extends State<BackgroundManager> {
  late String _selectedBackground;
  VideoPlayerController? _videoController;

  @override
  void initState() {
    super.initState();
    _initializeBackground();
  }

  void _initializeBackground() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final provider = Provider.of<PreferencesProvider>(context, listen: false);
      final String category = provider.backgroundCategory;

      final List<String> selectedList = _getBackgroundList(category);

      _selectedBackground = selectedList[Random().nextInt(selectedList.length)];

      if (_selectedBackground.endsWith('.mp4')) {
        _videoController = VideoPlayerController.asset(_selectedBackground)
          ..setLooping(true)
          ..initialize().then((_) {
            if (mounted) {
              _videoController!.play();
              setState(() {});
            }
          }).catchError((e) {
            debugPrint('Video load error: $e');
          });
      } else {
        setState(() {});
      }
    });
  }

  List<String> _getBackgroundList(String category) {
    switch (category) {
      case 'cyberpunk':
        return [
          for (int i = 1; i <= 18; i++) 'assets/backgrounds/cyberpunk/cyber$i.mp4',
          for (int i = 19; i <= 30; i++) 'assets/backgrounds/cyberpunk/cyber$i.jpg',
        ];
      case 'nature':
        return [
          for (int i = 1; i <= 26; i++) 'assets/backgrounds/nature/nature$i.mp4',
        ];
      case 'girls':
      default:
        return [
          for (int i = 1; i <= 14; i++) 'assets/backgrounds/girls/girl$i.jpg',
          for (int i = 15; i <= 30; i++) 'assets/backgrounds/girls/girl$i.mp4',
        ];
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
          Container(color: Colors.black.withOpacity(0.4)),
        ],
      ),
    );
  }
}
