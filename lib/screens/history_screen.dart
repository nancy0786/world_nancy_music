cat > lib/screens/history_screen.dart << 'EOF'
import 'package:flutter/material.dart';
import 'package:nancy_music_world/lib/services/queue_service.dart';
import 'package:nancy_music_world/lib/components/custom_app_bar.dart';

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
EOF
