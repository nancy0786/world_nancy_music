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
        const BackgroundManager(), // Neon video/image background
        Positioned.fill(
          child: Builder(
            builder: (context) {
              // If the child is already a Scaffold, don’t wrap again
              if (child is Scaffold) {
                return child;
              }

              // Wrap in Scaffold if not already
              return Scaffold(
                backgroundColor: Colors.transparent,
                appBar: appBar,
                floatingActionButton: floatingActionButton,
                bottomNavigationBar: bottomNavigationBar,
                body: child,
              );
            },
          ),
        ),
      ],
    );
  }
}
