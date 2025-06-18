import 'package:world_music_nancy/widgets/neon_aware_container.dart';
import 'package:world_music_nancy/widgets/neon_aware_container.dart';
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';

class SongPlayer extends StatelessWidget {
  final AudioPlayer player;
  final String title;
  final String artist;
  final String thumbnailUrl;

  const SongPlayer({
    Key? key,
    required this.player,
    required this.title,
    required this.artist,
    required this.thumbnailUrl,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 24),
        ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: Image.network(
            thumbnailUrl,
            height: 200,
            width: 200,
            fit: BoxFit.cover,
            errorBuilder: (_, __, ___) => NeonAwareContainer(
              height: 200,
              width: 200,
              color: Colors.grey[800],
              child: const Icon(Icons.music_note, color: Colors.white, size: 60),
            ),
          ),
        ),
        const SizedBox(height: 16),
        Text(
          title,
          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 8),
        Text(
          artist,
          style: const TextStyle(fontSize: 14, color: Colors.grey),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 16),
        StreamBuilder<Duration>(
          stream: player.positionStream,
          builder: (context, snapshot) {
            final position = snapshot.data ?? Duration.zero;
            return StreamBuilder<Duration?>(
              stream: player.durationStream,
              builder: (context, durationSnapshot) {
                final duration = durationSnapshot.data ?? Duration.zero;
                return Column(
                  children: [
                    Slider(
                      value: position.inSeconds.toDouble(),
                      max: duration.inSeconds.toDouble(),
                      onChanged: (value) {
                        player.seek(Duration(seconds: value.toInt()));
                      },
                      activeColor: Colors.pinkAccent,
                      inactiveColor: Colors.grey[700],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(_formatTime(position), style: const TextStyle(color: Colors.white)),
                        Text(_formatTime(duration), style: const TextStyle(color: Colors.white)),
                      ],
                    )
                  ],
                );
              },
            );
          },
        ),
        const SizedBox(height: 16),
        StreamBuilder<PlayerState>(
          stream: player.playerStateStream,
          builder: (context, snapshot) {
            final isPlaying = snapshot.data?.playing ?? false;
            return Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  icon: const Icon(Icons.skip_previous),
                  iconSize: 40,
                  color: Colors.white,
                  onPressed: player.hasPrevious ? player.seekToPrevious : null,
                ),
                IconButton(
                  icon: Icon(isPlaying ? Icons.pause_circle_filled : Icons.play_circle_fill),
                  iconSize: 60,
                  color: Colors.pinkAccent,
                  onPressed: () {
                    isPlaying ? player.pause() : player.play();
                  },
                ),
                IconButton(
                  icon: const Icon(Icons.skip_next),
                  iconSize: 40,
                  color: Colors.white,
                  onPressed: player.hasNext ? player.seekToNext : null,
                ),
              ],
            );
          },
        ),
      ],
    );
  }

  String _formatTime(Duration duration) {
    final twoDigits = (int n) => n.toString().padLeft(2, '0');
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));
    return "$minutes:$seconds";
  }
}
