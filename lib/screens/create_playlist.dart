import 'package:flutter/material.dart';
import 'package:world_music_nancy/components/base_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:world_music_nancy/components/base_screen.dart';
import 'package:image_picker/image_picker.dart';
import 'package:world_music_nancy/components/base_screen.dart';
import 'dart:io';
import 'package:world_music_nancy/components/base_screen.dart';
import 'package:world_music_nancy/components/custom_app_bar.dart';
import 'package:world_music_nancy/components/base_screen.dart';

class CreatePlaylistScreen extends StatefulWidget {
  const CreatePlaylistScreen({super.key});

  @override
  State<CreatePlaylistScreen> createState() => _CreatePlaylistScreenState();
}

class _CreatePlaylistScreenState extends State<CreatePlaylistScreen> {
  final TextEditingController _nameController = TextEditingController();
  bool _isPublic = true;
  File? _thumbnail;

  Future<void> _pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() {
        _thumbnail = File(image.path);
      });
    }
  }

  Future<void> _savePlaylist() async {
    final prefs = await SharedPreferences.getInstance();
    String name = _nameController.text.trim();
    if (name.isEmpty) return;

    List<String> playlists = prefs.getStringList('playlists') ?? [];

    // Store as name|privacy|thumbnailPath
    String data = '$name|${_isPublic ? "public" : "private"}|${_thumbnail?.path ?? ""}';
    playlists.add(data);
    await prefs.setStringList('playlists', playlists);

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return BaseScreen(child: Scaffold(backgroundColor: Colors.transparent,
      appBar: AppBar(title: const Text("Create Playlist")),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(labelText: "Playlist Name"),
            ),
            const SizedBox(height: 15),
            Row(
              children: [
                const Text("Make playlist public?"),
                const SizedBox(width: 10),
                Switch(
                  value: _isPublic,
                  onChanged: (v) => setState(() => _isPublic = v),
                ),
              ],
            ),
            const SizedBox(height: 15),
            GestureDetector(
              onTap: _pickImage,
              child: Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.tealAccent),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: _thumbnail != null
                    ? Image.file(_thumbnail!, fit: BoxFit.cover)
                    : const Center(child: Text("Pick Thumbnail")),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _savePlaylist,
              child: const Text("Create Playlist"),
            ),
          ],
        ),
      ),
    );
  }
);
}
