cat > lib/widgets/queue_sheet.dart << 'EOF'
import 'package:flutter/material.dart';
import 'package:nancy_music_world/lib/services/queue_service.dart';

class QueueSheet extends StatelessWidget {
  const QueueSheet({super.key});

  @override
  Widget build(BuildContext context) {
    final queue = QueueService().queue;
    final current = QueueService().currentIndex;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: const BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text(
            '🎶 Up Next',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.tealAccent),
          ),
          const SizedBox(height: 10),
          ListView.builder(
            shrinkWrap: true,
            itemCount: queue.length,
            itemBuilder: (context, index) {
              final song = queue[index];
              final isCurrent = index == current;
              return ListTile(
                leading: Icon(isCurrent ? Icons.play_arrow : Icons.music_note, color: Colors.white),
                title: Text(song, style: TextStyle(color: isCurrent ? Colors.tealAccent : Colors.white)),
              );
            },
          ),
        ],
      ),
    );
  }
}
EOF
