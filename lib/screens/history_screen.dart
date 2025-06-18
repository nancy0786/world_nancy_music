import 'package:world_music_nancy/widgets/neon_aware_tile.dart';
import 'package:world_music_nancy/widgets/neon_aware_tile.dart';
import 'package:flutter/material.dart';
import 'package:world_music_nancy/components/base_screen.dart';
import 'package:world_music_nancy/services/queue_service.dart';
import 'package:world_music_nancy/components/common_widgets.dart';

class HistoryScreen extends StatelessWidget {
  const HistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final history = QueueService().history;

    return BaseScreen(
      appBar: AppBar(title: const Text("Listening History")),
      child: history.isEmpty
          ? const Center(
              child: Text(
                "No listening history found.",
                style: TextStyle(color: Colors.grey, fontSize: 16),
              ),
            )
          : ListView.builder(
              itemCount: history.length,
              itemBuilder: (context, index) {
                final song = history[index];
                return NeonAwareTile(
                  leading: Image.network(song['thumb'] ?? ''),
                  title: Text(song['title'] ?? 'Unknown Title'),
                  subtitle: Text(song['artist'] ?? ''),
                  onTap: () {
                    // Optional: Navigate to a player or details screen
                  },
                );
              },
            ),
    );
  }
}
