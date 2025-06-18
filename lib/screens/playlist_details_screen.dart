import 'dart:io';
import 'package:flutter/material.dart';
import 'package:world_music_nancy/components/base_screen.dart';

class PlaylistDetailsScreen extends StatelessWidget {
  final String playlistName;
  final String imagePath;
  final String visibility;

  const PlaylistDetailsScreen({
    super.key,
    required this.playlistName,
    required this.imagePath,
    required this.visibility,
  });

  @override
  Widget build(BuildContext context) {
    return BaseScreen(
      child: Scaffold(
        appBar: AppBar(
          title: Text(playlistName),
          backgroundColor: Colors.black,
        ),
        backgroundColor: Colors.transparent,
        body: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              if (imagePath.isNotEmpty && File(imagePath).existsSync())
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.file(File(imagePath), height: 200, fit: BoxFit.cover),
                )
              else
                Container(
                  height: 200,
                  color: Colors.grey[800],
                  alignment: Alignment.center,
                  child: const Icon(Icons.music_note, color: Colors.white70, size: 50),
                ),
              const SizedBox(height: 16),
              Text(
                "Visibility: ${visibility.toUpperCase()}",
                style: const TextStyle(color: Colors.white70, fontSize: 16),
              ),
              const SizedBox(height: 24),
              const Text(
                "🧪 Song list coming soon...",
                style: TextStyle(color: Colors.cyanAccent),
              )
            ],
          ),
        ),
      ),
    );
  }
}
