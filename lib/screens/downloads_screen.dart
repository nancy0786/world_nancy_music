import 'dart:io';
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:world_music_nancy/components/base_screen.dart';
import 'package:world_music_nancy/screens/player_screen.dart';
import 'package:world_music_nancy/services/download_manager.dart';
import 'package:world_music_nancy/widgets/neon_aware_tile.dart';

class DownloadsScreen extends StatefulWidget {
  const DownloadsScreen({super.key});

  @override
  State<DownloadsScreen> createState() => _DownloadsScreenState();
}

class _DownloadsScreenState extends State<DownloadsScreen> {
  List<Map<String, dynamic>> _songs = [];
  List<String> _rawData = [];
  late AudioPlayer _player;

  @override
  void initState() {
    super.initState();
    _player = AudioPlayer();
    _loadSongs();
  }

  Future<void> _loadSongs() async {
    final downloaded = await DownloadManager.getDownloadedSongs();
    final prefs = await SharedPreferences.getInstance();
    final stored = prefs.getStringList('downloadedSongs') ?? [];

    setState(() {
      _songs = downloaded;
      _rawData = List.from(stored);
    });
  }

  Future<void> _deleteSong(int index) async {
    final prefs = await SharedPreferences.getInstance();
    final removedRaw = _rawData[index];
    final removedParsed = _songs[index];

    setState(() {
      _rawData.removeAt(index);
      _songs.removeAt(index);
    });

    await prefs.setStringList('downloadedSongs', _rawData);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text("🗑️ Song deleted"),
        duration: const Duration(seconds: 5),
        action: SnackBarAction(
          label: "UNDO",
          onPressed: () async {
            setState(() {
              _rawData.insert(index, removedRaw);
              _songs.insert(index, removedParsed);
            });
            await prefs.setStringList('downloadedSongs', _rawData);
          },
        ),
      ),
    );
  }

  Future<void> _playSong(Map<String, dynamic> song) async {
    final path = song['filePath'];
    if (path == null || !File(path).existsSync()) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("⚠️ File not found")),
      );
      return;
    }

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => PlayerScreen(
          title: song['title'] ?? 'No Title',
          author: song['author'] ?? 'Unknown',
          url: path, // local path
        ),
      ),
    );
  }

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
        body: _songs.isEmpty
            ? const Center(
                child: Text("No downloaded songs found.", style: TextStyle(color: Colors.white70)),
              )
            : ListView.builder(
                itemCount: _songs.length,
                itemBuilder: (context, index) {
                  final song = _songs[index];
                  return NeonAwareTile(
                    leading: song['thumb'] != null
                        ? Image.network(song['thumb'], width: 50, height: 50, fit: BoxFit.cover)
                        : const Icon(Icons.music_note, color: Colors.white),
                    title: Text(song['title'] ?? 'No Title', style: const TextStyle(color: Colors.white)),
                    subtitle: Text(song['author'] ?? 'Unknown', style: const TextStyle(color: Colors.white54)),
                    onTap: () => _playSong(song),
                    trailing: IconButton(
                      icon: const Icon(Icons.delete_outline, color: Colors.redAccent),
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (_) => AlertDialog(
                            backgroundColor: Colors.black87,
                            title: const Text("Delete Song?", style: TextStyle(color: Colors.white)),
                            content: const Text("Are you sure you want to delete this song?",
                                style: TextStyle(color: Colors.white60)),
                            actions: [
                              TextButton(
                                child: const Text("Cancel"),
                                onPressed: () => Navigator.pop(context),
                              ),
                              TextButton(
                                child: const Text("Delete", style: TextStyle(color: Colors.redAccent)),
                                onPressed: () {
                                  Navigator.pop(context);
                                  _deleteSong(index);
                                },
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  );
                },
              ),
      ),
    );
  }
}
