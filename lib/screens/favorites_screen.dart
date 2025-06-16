import 'package:flutter/material.dart';
import 'package:world_music_nancy/components/base_screen.dart';

class FavoritesScreen extends StatelessWidget {
  const FavoritesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BaseScreen(child: Scaffold(backgroundColor: Colors.transparent,
      appBar: AppBar(title: const Text("Favorites")),
      body: const Center(child: Text('Favorites Page')),
    );
  }
);
}
