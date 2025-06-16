import 'dart:io';
import 'package:world_music_nancy/components/base_screen.dart';
import 'package:flutter/material.dart';
import 'package:world_music_nancy/components/base_screen.dart';
import 'package:just_audio/just_audio.dart';
import 'package:world_music_nancy/components/base_screen.dart';
import '../../components/custom_widgets.dart';
import 'package:world_music_nancy/components/base_screen.dart';
import 'package:world_music_nancy/services/download_manager.dart';
import 'package:world_music_nancy/components/base_screen.dart';

class DownloadsScreen extends StatefulWidget {
  const DownloadsScreen({super.key});

  @override
  State<DownloadsScreen> createState() => _DownloadsScreenState();
}

class _DownloadsScreenState extends State<DownloadsScreen> {
  final AudioPlayer _player = AudioPlayer();

  @override
  Widget build(BuildContext context) {
          }

          final songs = snapshot.data!;
          if (songs.isEmpty) {
            return const Center(child: Text("No downloaded songs found."));
          }

          return ListView.builder(
            itemCount: songs.length,
            itemBuilder: (context, index) {
              final song = songs[index];
              return ListTile(
                leading: Image.network(song['thumb'] ?? ''),
                title: Text(song['title'] ?? 'No Title'),
                onTap: () async {
                  final path = song['filePath'];
                  if (path != null && File(path).existsSync()) {
                    await _player.setFilePath(path);
                    _player.play();
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("File not found.")),
                    );
                  }
                },
              );
            },
          );
        },
      ),
    );
  }
);
}
