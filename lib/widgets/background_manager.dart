📄 lib/widgets/background_manager.dart

import 'package:world_music_nancy/widgets/neon_aware_container.dart';
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
  String? _selectedBackground;
  VideoPlayerController? _videoController;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _loadBackground();
  }

  void _loadBackground() async {
    final provider = Provider.of<PreferencesProvider>(context, listen: false);
    final category = provider.backgroundCategory;

    final backgrounds = _getCategoryBackgrounds(category);
    if (backgrounds.isEmpty) return;
    final selected = backgrounds[Random().nextInt(backgrounds.length)];

    if (selected.endsWith('.mp4')) {
      final controller = VideoPlayerController.asset(selected);
      await controller.initialize().catchError((e) {
        debugPrint("Video init error: $e");
      });

      controller.setLooping(true);
      controller.setVolume(0); // 🔇 Mute video audio
      controller.play();

      setState(() {
        _selectedBackground = selected;
        _videoController = controller;
      });
    } else {
      setState(() {
        _selectedBackground = selected;
      });
    }
  }

  List<String> _getCategoryBackgrounds(String category) {
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
      case 'dark':
        return ['assets/backgrounds/dark.jpg'];
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
    final isVideo = _selectedBackground?.endsWith('.mp4') ?? false;

    return Positioned.fill(
      child: Stack(
        children: [
          if (_selectedBackground == null)
            const ColoredBox(color: Colors.black)

          else if (isVideo)
            (_videoController != null && _videoController!.value.isInitialized)
                ? FittedBox(
                    fit: BoxFit.cover,
                    child: SizedBox(
                      width: _videoController!.value.size.width,
                      height: _videoController!.value.size.height,
                      child: VideoPlayer(_videoController!),
                    ),
                  )
                : const ColoredBox(color: Colors.black)

          else
            Image.asset(
              _selectedBackground!,
              fit: BoxFit.cover,
              width: double.infinity,
              height: double.infinity,
              errorBuilder: (_, __, ___) => const ColoredBox(color: Colors.black),
            ),

          NeonAwareContainer(
            color: Colors.black.withOpacity(0.4),
            child: const SizedBox.shrink(),
          ),
        ],
      ),
    );
  }
}
