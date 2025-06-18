import 'package:world_music_nancy/widgets/neon_aware_container.dart';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:world_music_nancy/components/base_screen.dart';
import 'package:world_music_nancy/screens/playlist_details_screen.dart';

class SavedPlaylistsScreen extends StatefulWidget {
  const SavedPlaylistsScreen({super.key});

  @override
  State<SavedPlaylistsScreen> createState() => _SavedPlaylistsScreenState();
}

class _SavedPlaylistsScreenState extends State<SavedPlaylistsScreen> {
  List<Map<String, String>> _playlists = [];
  List<String> _rawData = [];

  @override
  void initState() {
    super.initState();
    _loadPlaylists();
  }

  Future<void> _loadPlaylists() async {
    final prefs = await SharedPreferences.getInstance();
    final saved = prefs.getStringList('playlists') ?? [];
    _rawData = List.from(saved);

    final parsed = saved.map((data) {
      final parts = data.split('|');
      return {
        'name': parts[0],
        'visibility': parts[1],
        'imagePath': parts.length > 2 ? parts[2] : '',
      };
    }).toList();

    setState(() => _playlists = parsed);
  }

  Future<void> _deletePlaylist(int index) async {
    final prefs = await SharedPreferences.getInstance();
    final removedPlaylist = _rawData[index];

    setState(() {
      _rawData.removeAt(index);
      _playlists.removeAt(index);
    });

    await prefs.setStringList('playlists', _rawData);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Playlist deleted'),
        duration: const Duration(seconds: 5),
        action: SnackBarAction(
          label: 'UNDO',
          onPressed: () async {
            setState(() {
              _rawData.insert(index, removedPlaylist);
              final parts = removedPlaylist.split('|');
              _playlists.insert(index, {
                'name': parts[0],
                'visibility': parts[1],
                'imagePath': parts.length > 2 ? parts[2] : '',
              });
            });
            await prefs.setStringList('playlists', _rawData);
          },
        ),
      ),
    );
  }

  void _openPlaylist(Map<String, String> playlist) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => PlaylistDetailsScreen(
          playlistName: playlist['name'] ?? '',
          imagePath: playlist['imagePath'] ?? '',
          visibility: playlist['visibility'] ?? '',
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BaseScreen(
      child: Scaffold(
        appBar: AppBar(
          title: const Text("📁 Saved Playlists"),
          backgroundColor: Colors.black,
          centerTitle: true,
        ),
        backgroundColor: Colors.transparent,
        body: _playlists.isEmpty
            ? const Center(
                child: Text(
                  "No playlists saved yet.",
                  style: TextStyle(color: Colors.white70),
                ),
              )
            : Padding(
                padding: const EdgeInsets.all(16),
                child: GridView.builder(
                  itemCount: _playlists.length,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 0.85,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 16,
                  ),
                  itemBuilder: (context, index) {
                    final playlist = _playlists[index];
                    return GestureDetector(
                      onTap: () => _openPlaylist(playlist),
                      onLongPress: () => _deletePlaylist(index),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Expanded(
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(12),
                              child: playlist['imagePath'] != ''
                                  ? Image.file(
                                      File(playlist['imagePath']!),
                                      fit: BoxFit.cover,
                                    )
                                  : NeonAwareContainer(
                                      color: Colors.grey[800],
                                      child: const Icon(Icons.music_note, color: Colors.white70, size: 40),
                                    ),
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            playlist['name'] ?? '',
                            style: const TextStyle(
                              color: Colors.cyanAccent,
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
      ),
    );
  }
}
