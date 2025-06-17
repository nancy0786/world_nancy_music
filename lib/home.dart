import 'package:flutter/material.dart';
import 'package:world_music_nancy/screens/home_page_with_nav.dart';

/// HomePage now correctly loads the bottom navigation screen.
class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return const HomePageWithNav(); // ✅ Correct main navigation screen
  }
}
