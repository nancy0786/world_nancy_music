import 'dart:math';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:video_player/video_player.dart';
import 'package:world_music_nancy/providers/preferences_provider.dart';
import 'package:world_music_nancy/widgets/neon_aware_container.dart';

class BackgroundManager extends StatefulWidget {
  const BackgroundManager({super.key});

  @override
  State<BackgroundManager> createState() => _BackgroundManagerState();
}

class _BackgroundManagerState extends State<BackgroundManager> with WidgetsBindingObserver {
  String? _currentBackground;
  VideoPlayerController? _videoController;

  String? _category;
  List<String> _nextBackgrounds = [];
  int _currentIndex = 0;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _loadCategoryAndPreselect();
  }

  void _loadCategoryAndPreselect() async {
    final provider = Provider.of<PreferencesProvider>(context, listen: false);
    final category = provider.backgroundCategory;

    // Kill old queue if category changed
    if (_category != category) {
      _category = category;
      _currentIndex = 0;
      _nextBackgrounds = _generateQueue(category);
    }

    _setNextBackground();
  }

  List<String> _generateQueue(String category) {
    final all = _getCategoryBackgrounds(category);
    all.shuffle();
    return all.take(10).toList();
  }

  void _setNextBackground() async {
    if (_nextBackgrounds.isEmpty) return;

    final selected = _nextBackgrounds[_currentIndex % _nextBackgrounds.length];
    _currentIndex++;

    _videoController?.dispose();
    _videoController = null;

    if (selected.endsWith('.mp4')) {
      final controller = VideoPlayerController.asset(selected);
      await controller.initialize().catchError((e) => debugPrint("Video error: $e"));
      controller.setLooping(true);
      controller.setVolume(0);
      controller.play();
      setState(() {
        _currentBackground = selected;
        _videoController = controller;
      });
    } else {
      setState(() {
        _currentBackground = selected;
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
    final isVideo = _currentBackground?.endsWith('.mp4') ?? false;

    return Positioned.fill(
      child: IgnorePointer( // prevent background from responding to taps
        child: Stack(
          fit: StackFit.expand,
          children: [
            if (_currentBackground == null)
              const ColoredBox(color: Colors.black)

            else if (isVideo && _videoController != null && _videoController!.value.isInitialized)
              FittedBox(
                fit: BoxFit.cover,
                child: SizedBox(
                  width: _videoController!.value.size.width,
                  height: _videoController!.value.size.height,
                  child: VideoPlayer(_videoController!),
                ),
              )

            else
              Image.asset(
                _currentBackground!,
                fit: BoxFit.cover,
                width: double.infinity,
                height: double.infinity,
                filterQuality: FilterQuality.high,
                errorBuilder: (_, __, ___) => const ColoredBox(color: Colors.black),
              ),

            Positioned.fill(
              child: NeonAwareContainer(
                color: Colors.black.withOpacity(0.4),
                child: const SizedBox.shrink(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
