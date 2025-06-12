import 'package:flutter/material.dart';
import 'package:nancy_music_world/services/queue_service.dart';
import 'package:nancy_music_world/components/common_widgets.dart';

class HistoryScreen extends StatelessWidget {
  const HistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final history = QueueService().history;

    return Scaffold(
      appBar: AppBar(title: const Text('Playback History')),
      body: ListView.builder(
        itemCount: history.length,
        itemBuilder: (context, index) {
          final song = history[index];
          return ListTile(
            title: Text(song),
          );
        },
      ),
    );
  }
}
