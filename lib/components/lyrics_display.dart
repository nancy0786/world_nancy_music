
import 'package:flutter/material.dart';

class LyricsDisplay extends StatelessWidget {
  final List<String> lyrics;
  final int currentLine;

  const LyricsDisplay({
    super.key,
    required this.lyrics,
    required this.currentLine,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: lyrics.length,
      itemBuilder: (context, index) {
        final isActive = index == currentLine;

        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 4.0),
          child: Center(
            child: Text(
              lyrics[index],
              textAlign: TextAlign.center,
              style: TextStyle(
                color: isActive ? Colors.cyanAccent : Colors.white70,
                fontSize: isActive ? 20 : 16,
                fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
                shadows: isActive
                    ? [
                        Shadow(
                          color: Colors.cyanAccent.withOpacity(0.6),
                          blurRadius: 10,
                          offset: const Offset(0, 0),
                        ),
                      ]
                    : [],
              ),
            ),
          ),
        );
      },
    );
  }
}
