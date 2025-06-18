import 'package:flutter/material.dart';
import 'package:world_music_nancy/screens/player_screen.dart';

class NowPlayingCard extends StatelessWidget {
  final String? title;
  final String? artist;
  final String? thumbnailUrl;
  final String? audioUrl;

  const NowPlayingCard({
    super.key,
    required this.title,
    required this.artist,
    required this.thumbnailUrl,
    required this.audioUrl,
  });

  @override
  Widget build(BuildContext context) {
    if (title == null || audioUrl == null) {
      return const Padding(
        padding: EdgeInsets.all(8.0),
        child: Text(
          "Nothing is playing",
          style: TextStyle(
            color: Colors.white54,
            fontStyle: FontStyle.italic,
          ),
        ),
      );
    }

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => PlayerScreen(
              title: title!,
              author: artist ?? 'Unknown',
              url: audioUrl!,
            ),
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: Colors.black.withOpacity(0.6),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.pinkAccent, width: 1),
          boxShadow: [
            BoxShadow(
              color: Colors.pinkAccent.withOpacity(0.3),
              blurRadius: 12,
              spreadRadius: 1,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Image.network(
                thumbnailUrl ?? '',
                height: 50,
                width: 50,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => Container(
                  width: 50,
                  height: 50,
                  color: Colors.grey[800],
                  child: const Icon(Icons.music_note, color: Colors.white54),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title!,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: Color(0xFF00FFFF),
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                  Text(
                    artist ?? '',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: Colors.white70,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
            const Icon(Icons.equalizer_rounded, color: Colors.pinkAccent),
          ],
        ),
      ),
    );
  }
}
