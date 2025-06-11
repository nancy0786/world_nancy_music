cat > lib/screens/downloads_screen.dart << 'EOF'
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:nancy_music_world/lib/services/download_manager.dart';
import 'package:nancy_music_world/lib/components/custom_app_bar.dart';

class DownloadsScreen extends StatefulWidget {
  const DownloadsScreen({super.key});

  @override
  State<DownloadsScreen> createState() => _DownloadsScreenState();
}

class _DownloadsScreenState extends State<DownloadsScreen> {
  final AudioPlayer _player = AudioPlayer();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Offline Downloads")),
      body: FutureBuilder(
        future: DownloadManager.getDownloadedSongs(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) return const CircularProgressIndicator();
          final songs = snapshot.data!;
          if (songs.isEmpty) return const Center(child: Text("No songs downloaded"));

          return ListView.builder(
            itemCount: songs.length,
            itemBuilder: (context, index) {
              final song = songs[index];
              return ListTile(
                leading: Image.network(song['thumbnail']!, width: 50),
                title: Text(song['title']!),
                onTap: () async {
                  await _player.setFilePath(song['path']!);
                  _player.play();
                },
              );
            },
          );
        },
      ),
    );
  }
}
EOF
