import 'package:flutter/material.dart';
import 'package:world_music_nancy/widgets/background_manager.dart';

class BaseScreen extends StatelessWidget {
  final Widget child;
  final PreferredSizeWidget? appBar;
  final Widget? floatingActionButton;
  final Widget? bottomNavigationBar;

  const BaseScreen({
    super.key,
    required this.child,
    this.appBar,
    this.floatingActionButton,
    this.bottomNavigationBar,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // ✅ Background behind everything
        Positioned.fill(
          child: const BackgroundManager(),
        ),

        // ✅ Foreground screen content
        Positioned.fill(
          child: Scaffold(
            backgroundColor: Colors.transparent,
            appBar: appBar,
            body: child,
            floatingActionButton: floatingActionButton,
            bottomNavigationBar: bottomNavigationBar,
          ),
        ),
      ],
    );
  }
}
