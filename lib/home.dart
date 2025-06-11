import 'package:flutter/material.dart';
import 'package:nancy_music_world/screens/home_screen.dart'; // You already created this!

/// HomePage is a simple wrapper around your main screen.
class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return const HomeScreen(); // Loads your YouTube + Favorites UI
  }
}
