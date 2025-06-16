import 'dart:io';
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:world_music_nancy/components/base_screen.dart';
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
      child: Scaffold(
        appBar: AppBar(title: const Text("Downloads")),
        backgroundColor: Colors.transparent,
        body: FutureBuilder<List<Map<String, dynamic>>>(
          future: DownloadManager().getDownloadedSongs(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return const Center(
                child: Text("No downloaded songs found.", style: TextStyle(color: Colors.white)),
              );
            }

            final songs = snapshot.data!;
            return ListView.builder(
              itemCount: songs.length,
              itemBuilder: (context, index) {
                final song = songs[index];
                return ListTile(
                  leading: song['thumb'] != null
                      ? Image.network(song['thumb'], width: 50, height: 50, fit: BoxFit.cover)
                      : const Icon(Icons.music_note, color: Colors.white),
                  title: Text(song['title'] ?? 'No Title', style: const TextStyle(color: Colors.white)),
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
      ),
    );
  }
}
