import 'package:flutter/material.dart';
import 'package:world_music_nancy/services/queue_service.dart';
import 'package:world_music_nancy/components/common_widgets.dart';

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
