import 'package:flutter/material.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:world_music_nancy/components/base_screen.dart';
import 'package:world_music_nancy/components/custom_app_bar.dart';

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
    String data = '$name|${_isPublic ? "public" : "private"}|${_thumbnail?.path ?? ""}';
    playlists.add(data);
    await prefs.setStringList('playlists', playlists);

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return BaseScreen(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: const CustomAppBar(title: 'Create Playlist'),
        body: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              TextField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: 'Playlist Name'),
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  const Text('Public'),
                  Switch(
                    value: _isPublic,
                    onChanged: (val) {
                      setState(() {
                        _isPublic = val;
                      });
                    },
                  ),
                ],
              ),
              const SizedBox(height: 10),
              ElevatedButton.icon(
                onPressed: _pickImage,
                icon: const Icon(Icons.image),
                label: const Text("Pick Thumbnail"),
              ),
              if (_thumbnail != null)
                Padding(
                  padding: const EdgeInsets.only(top: 10),
                  child: Image.file(
                    _thumbnail!,
                    width: 100,
                    height: 100,
                    fit: BoxFit.cover,
                  ),
                ),
              const Spacer(),
              ElevatedButton(
                onPressed: _savePlaylist,
                child: const Text('Save Playlist'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
