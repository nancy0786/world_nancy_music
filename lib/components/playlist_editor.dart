# lib/components/playlist_editor.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:nancy_music_world/lib/providers/playlist_provider.dart';

class PlaylistEditor extends StatefulWidget {
  const PlaylistEditor({super.key});

  @override
  State<PlaylistEditor> createState() => _PlaylistEditorState();
}

class _PlaylistEditorState extends State<PlaylistEditor> {
  final _controller = TextEditingController();
  bool _isPublic = false;

  void _createPlaylist() {
    final name = _controller.text.trim();
    if (name.isNotEmpty) {
      context.read<PlaylistProvider>().createPlaylist(name, isPublic: _isPublic);
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Colors.black,
      title: const Text("New Playlist", style: TextStyle(color: Colors.cyanAccent)),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: _controller,
            style: const TextStyle(color: Colors.white),
            decoration: const InputDecoration(
              labelText: "Playlist Name",
              labelStyle: TextStyle(color: Colors.cyanAccent),
              enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.cyanAccent),
              ),
            ),
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              const Text("Public", style: TextStyle(color: Colors.white)),
              Switch(
                value: _isPublic,
                onChanged: (val) => setState(() => _isPublic = val),
                activeColor: Colors.cyanAccent,
              ),
            ],
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: Navigator.of(context).pop,
          child: const Text("Cancel", style: TextStyle(color: Colors.redAccent)),
        ),
        TextButton(
          onPressed: _createPlaylist,
          child: const Text("Create", style: TextStyle(color: Colors.greenAccent)),
        ),
      ],
    );
  }
}
