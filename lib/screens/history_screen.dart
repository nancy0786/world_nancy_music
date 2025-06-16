import 'package:flutter/material.dart';
import 'package:world_music_nancy/components/base_screen.dart';
import 'package:world_music_nancy/services/queue_service.dart';
import 'package:world_music_nancy/components/base_screen.dart';
import 'package:world_music_nancy/components/common_widgets.dart';
import 'package:world_music_nancy/components/base_screen.dart';

class HistoryScreen extends StatelessWidget {
  const HistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final history = QueueService().history;

    return BaseScreen(child: Scaffold(backgroundColor: Colors.transparent,
      appBar: AppBar(title: const Text('Playback History')),
      body: ListView.builder(
        itemCount: history.length,
        itemBuilder: (context, index) {
          final song = history[index];
          return ListTile(
          title: Text(song['title'] ?? 'Unknown'),
          );
        },
      ),
    );
  }
);
}
