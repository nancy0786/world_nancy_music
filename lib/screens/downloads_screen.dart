import 'dart:io';
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:world_music_nancy/components/base_screen.dart';
import 'package:world_music_nancy/components/custom_widgets.dart';
import 'package:world_music_nancy/services/download_manager.dart';

class DownloadsScreen extends StatefulWidget {
  const DownloadsScreen({super.key});

  @override
  State<DownloadsScreen> createState() => _DownloadsScreenState();
}

class _DownloadsScreenState extends State<DownloadsScreen> {
  final AudioPlayer _player = AudioPlayer();

  @override
  void dispose() {
    _player.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BaseScreen(
      appBar: AppBar(title: const Text("Downloads")),
      child: FutureBuilder<List<Map<String, dynamic>>>(
        future: DownloadManager().getDownloadedSongs(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text("No downloaded songs found."));
          }

          final songs = snapshot.data!;
          return ListView.builder(
            itemCount: songs.length,
            itemBuilder: (context, index) {
              final song = songs[index];
              return ListTile(
                leading: song['thumb'] != null
                    ? Image.network(song['thumb'])
                    : const Icon(Icons.music_note),
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
}
