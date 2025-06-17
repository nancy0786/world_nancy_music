import 'package:flutter/material.dart';
import 'package:world_music_nancy/widgets/background_manager.dart';

class BaseScreen extends StatelessWidget {
  final PreferredSizeWidget? appBar;
  final Widget child;
  final Widget? floatingActionButton;
  final Widget? bottomNavigationBar;

  const BaseScreen({
    super.key,
    this.appBar,
    required this.child,
    this.floatingActionButton,
    this.bottomNavigationBar,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        const BackgroundManager(), // background
        Scaffold(
          backgroundColor: Colors.transparent,
          appBar: appBar,
          body: child,
          floatingActionButton: floatingActionButton,
          bottomNavigationBar: bottomNavigationBar,
        ),
      ],
    );
  }
}
