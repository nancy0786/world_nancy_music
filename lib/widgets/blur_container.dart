import 'package:world_music_nancy/widgets/neon_aware_container.dart';
import 'package:world_music_nancy/widgets/neon_aware_container.dart';
import 'dart:ui';
import 'package:flutter/material.dart';

class BlurContainer extends StatelessWidget {
  final Widget child;
  final double blurX;
  final double blurY;
  final Color overlayColor;

  const BlurContainer({
    super.key,
    required this.child,
    this.blurX = 10,
    this.blurY = 10,
    this.overlayColor = Colors.black26,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.all(Radius.circular(16)), // Updated with const constructor
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: blurX, sigmaY: blurY),
        child: NeonAwareContainer(
          decoration: BoxDecoration(
            color: overlayColor,
            borderRadius: BorderRadius.all(Radius.circular(16)), // Updated with const constructor
            border: Border.all(color: Colors.white24, width: 0.5),
          ),
          child: child,
        ),
      ),
    );
  }
}
