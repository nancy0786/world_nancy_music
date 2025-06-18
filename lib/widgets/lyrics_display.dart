import 'package:world_music_nancy/widgets/neon_aware_container.dart';
import 'package:world_music_nancy/widgets/neon_aware_container.dart';
import 'package:flutter/material.dart';
import 'dart:async';

class LyricsDisplay extends StatefulWidget {
  final List<Map<String, dynamic>> syncedLyrics;

  const LyricsDisplay({super.key, required this.syncedLyrics});

  @override
  State<LyricsDisplay> createState() => _LyricsDisplayState();
}

class _LyricsDisplayState extends State<LyricsDisplay> {
  int _currentLine = 0;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _startSync();
  }

  void _startSync() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      final currentSecond = timer.tick;

      for (int i = 0; i < widget.syncedLyrics.length; i++) {
        if (widget.syncedLyrics[i]['time'] == currentSecond) {
          setState(() {
            _currentLine = i;
          });
          break;
        }
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return NeonAwareContainer(
      height: 180,
      padding: const EdgeInsets.all(16),
      child: ListView.builder(
        itemCount: widget.syncedLyrics.length,
        itemBuilder: (context, index) {
          final isCurrent = index == _currentLine;
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 4.0),
            child: Text(
              widget.syncedLyrics[index]['line'],
              textAlign: TextAlign.center,
              style: TextStyle(
                color: isCurrent ? Colors.tealAccent : Colors.white60,
                fontSize: isCurrent ? 18 : 16,
                fontWeight: isCurrent ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          );
        },
      ),
    );
  }
}
