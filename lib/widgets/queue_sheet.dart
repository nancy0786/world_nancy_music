import 'package:flutter/material.dart';

class QueueSheet extends StatelessWidget {
  final List<Map<String, dynamic>> queue;
  final int currentIndex;
  final Function(int) onSongTap;

  const QueueSheet({
    Key? key,
    required this.queue,
    required this.currentIndex,
    required this.onSongTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.5,
      minChildSize: 0.3,
      maxChildSize: 0.9,
      builder: (context, scrollController) {
        return Container(
          decoration: BoxDecoration(
            color: Colors.black.withOpacity(0.9),
            borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
          ),
          child: ListView.builder(
            controller: scrollController,
            itemCount: queue.length,
            itemBuilder: (context, index) {
              final song = queue[index];
              final isCurrent = index == currentIndex;

              return ListTile(
                title: Text(
                  song['title'] ?? 'Unknown',
                  style: TextStyle(
                    color: isCurrent ? Colors.pinkAccent : Colors.white,
                    fontWeight: isCurrent ? FontWeight.bold : FontWeight.normal,
                  ),
                ),
                subtitle: Text(
                  song['artist'] ?? 'Unknown Artist',
                  style: TextStyle(color: Colors.grey[400]),
                ),
                trailing: isCurrent ? const Icon(Icons.play_arrow, color: Colors.pinkAccent) : null,
                onTap: () => onSongTap(index),
              );
            },
          ),
        );
      },
    );
  }
}
