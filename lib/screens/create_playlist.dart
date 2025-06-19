import 'package:world_music_nancy/widgets/neon_aware_button.dart';
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
  String? _error;

  Future<void> _pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() => _thumbnail = File(image.path));
    }
  }

  Future<void> _savePlaylist() async {
    String name = _nameController.text.trim();

    if (name.length < 3) {
      setState(() => _error = "Playlist name must be at least 3 letters");
      return;
    }

    final prefs = await SharedPreferences.getInstance();
    List<String> playlists = prefs.getStringList('playlists') ?? [];
    String visibility = _isPublic ? "public" : "private";
    String data = '$name|$visibility|${_thumbnail?.path ?? ""}';

    playlists.add(data);
    await prefs.setStringList('playlists', playlists);

    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('✅ Playlist added successfully!'),
        backgroundColor: Colors.greenAccent,
      ),
    );

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
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  labelText: 'Playlist Name',
                  labelStyle: const TextStyle(color: Colors.white70),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.white24),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.cyanAccent),
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  const Text('Visibility: ', style: TextStyle(color: Colors.white70)),
                  const SizedBox(width: 8),
                  const Icon(Icons.public, color: Colors.cyanAccent, size: 18),
                  const Text("Public", style: TextStyle(color: Colors.cyanAccent)),
                  Switch(
                    value: _isPublic,
                    onChanged: (val) => setState(() => _isPublic = val),
                    activeColor: Colors.pinkAccent,
                  ),
                  const Icon(Icons.lock, color: Colors.white60, size: 18),
                  const Text("Private", style: TextStyle(color: Colors.white60)),
                ],
              ),
              const SizedBox(height: 10),

              // ✅ NeonAwareButton with style now accepted
              NeonAwareButton(
                onTap: _pickImage,
                icon: const Icon(Icons.image, color: Colors.white),
                label: const Text("Pick Thumbnail", style: TextStyle(color: Colors.white)),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.pinkAccent,
                ),
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
              const SizedBox(height: 20),
              if (_error != null)
                Text(_error!, style: const TextStyle(color: Colors.redAccent)),

              const Spacer(),

              // ✅ Fixed: Use onPressed, not onTap
              ElevatedButton(
                onPressed: _savePlaylist,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.cyanAccent,
                  padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 14),
                ),
                child: const Text(
                  'Save Playlist',
                  style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
