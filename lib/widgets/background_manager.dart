# --------- lib/widgets/background_manager.dart ----------
cat > lib/widgets/background_manager.dart << 'EOF'
import 'dart:math';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:video_player/video_player.dart';

class BackgroundManager extends StatefulWidget {
  const BackgroundManager({super.key});

  @override
  State<BackgroundManager> createState() => _BackgroundManagerState();
}

class _BackgroundManagerState extends State<BackgroundManager> {
  String? selectedCategory;
  late Future<void> _initFuture;
  String? backgroundFile;
  bool isVideo = false;
  VideoPlayerController? _videoController;

  final Map<String, List<String>> backgroundAssets = {
    'girl': [
      ...List.generate(14, (i) => 'assets/backgrounds/girls/girl${i + 1}.jpg'),
      ...List.generate(16, (i) => 'assets/backgrounds/girls/girl${i + 15}.mp4'),
    ],
    'cyber': [
      ...List.generate(18, (i) => 'assets/backgrounds/cyberpunk/cyber${i + 1}.mp4'),
      ...List.generate(12, (i) => 'assets/backgrounds/cyberpunk/cyber${i + 19}.jpg'),
    ],
    'nature': [
      ...List.generate(26, (i) => 'assets/backgrounds/nature/nature${i + 1}.mp4'),
    ],
  };

  @override
  void initState() {
    super.initState();
    _initFuture = _loadCategoryAndBackground();
  }

  Future<void> _loadCategoryAndBackground() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    selectedCategory = prefs.getString('backgroundCategory') ?? 'girl';
    _selectNewBackground();
  }

  void _selectNewBackground() {
    final List<String> assets = backgroundAssets[selectedCategory!]!;
    String newBackground;
    do {
      newBackground = assets[Random().nextInt(assets.length)];
    } while (newBackground == backgroundFile);

    setState(() {
      backgroundFile = newBackground;
      isVideo = backgroundFile!.endsWith('.mp4');

      _videoController?.dispose();
      _videoController = null;

      if (isVideo) {
        _videoController = VideoPlayerController.asset(backgroundFile!)
          ..setLooping(true)
          ..setVolume(0)
          ..initialize().then((_) {
            setState(() {
              _videoController!.play();
            });
          });
      }
    });
  }

  void refreshBackgroundExternally() {
    _selectNewBackground();
  }

  @override
  void dispose() {
    _videoController?.dispose();
    super.dispose();
  }

  bool _isDaytime() {
    final hour = DateTime.now().hour;
    return hour >= 6 && hour < 18;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _initFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.done || backgroundFile == null) {
          return const SizedBox.shrink();
        }

        Widget backgroundWidget;
        if (isVideo && _videoController != null && _videoController!.value.isInitialized) {
          backgroundWidget = FittedBox(
            fit: BoxFit.cover,
            child: SizedBox(
              width: _videoController!.value.size.width,
              height: _videoController!.value.size.height,
              child: VideoPlayer(_videoController!),
            ),
          );
        } else {
          backgroundWidget = Image.asset(
            backgroundFile!,
            fit: BoxFit.cover,
            width: double.infinity,
            height: double.infinity,
            alignment: Alignment.center,
          );
        }

        return GestureDetector(
          onTap: _selectNewBackground,
          child: Stack(
            children: [
              AnimatedSwitcher(
                duration: const Duration(milliseconds: 900),
                switchInCurve: Curves.easeInOut,
                child: backgroundWidget,
              ),
              Container(
                color: _isDaytime()
                    ? Colors.white.withOpacity(0.08)
                    : Colors.black.withOpacity(0.25),
              ),
              BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
                child: Container(color: Colors.transparent),
              ),
            ],
          ),
        );
      },
    );
  }
}
EOF
