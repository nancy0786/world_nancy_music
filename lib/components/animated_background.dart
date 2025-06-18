import 'package:world_music_nancy/widgets/neon_aware_container.dart';
import 'package:world_music_nancy/widgets/neon_aware_container.dart';
import 'package:flutter/material.dart';
import '../widgets/background_manager.dart';

class AnimatedBackground extends StatelessWidget {
  final Widget child;

  const AnimatedBackground({Key? key, required this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        const BackgroundManager(),
        Positioned.fill(
          child: NeonAwareContainer(
            color: Colors.black.withOpacity(0.6),
          ),
        ),
        child,
      ],
    );
  }
}
