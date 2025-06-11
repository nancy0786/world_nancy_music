# File: lib/widgets/animated_loader.dart
# Displays Lottie loading animation (loading_girl.json)

import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class AnimatedLoader extends StatelessWidget {
  const AnimatedLoader({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Lottie.asset(
        'assets/lottie/loading_girl.json',
        width: 200,
        height: 200,
        fit: BoxFit.contain,
      ),
    );
  }
}
