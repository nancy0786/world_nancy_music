
import 'package:flutter/material.dart';

class ProfileEditor extends StatefulWidget {
  final String username;
  final String? profileImage;
  final Function(String username, String? imageUrl) onSave;

  const ProfileEditor({
    super.key,
    required this.username,
    required this.onSave,
    this.profileImage,
  });

  @override
  State<ProfileEditor> createState() => _ProfileEditorState();
}

class _ProfileEditorState extends State<ProfileEditor> {
  late TextEditingController _usernameController;
  String? _newImage;

  @override
  void initState() {
    super.initState();
    _usernameController = TextEditingController(text: widget.username);
    _newImage = widget.profileImage;
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Colors.black,
      title: const Text('Edit Profile', style: TextStyle(color: Colors.cyanAccent)),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          CircleAvatar(
            radius: 40,
            backgroundImage: _newImage != null ? NetworkImage(_newImage!) : null,
            child: _newImage == null ? const Icon(Icons.person, size: 40, color: Colors.white70) : null,
          ),
          const SizedBox(height: 8),
          TextField(
            controller: _usernameController,
            style: const TextStyle(color: Colors.white),
            decoration: const InputDecoration(
              labelText: "Username",
              labelStyle: TextStyle(color: Colors.cyanAccent),
              enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.cyanAccent),
              ),
              focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.cyanAccent, width: 2),
              ),
            ),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel', style: TextStyle(color: Colors.grey)),
        ),
        ElevatedButton(
          onPressed: () {
            widget.onSave(_usernameController.text.trim(), _newImage);
            Navigator.pop(context);
          },
          style: ElevatedButton.styleFrom(backgroundColor: Colors.cyanAccent),
          child: const Text('Save', style: TextStyle(color: Colors.black)),
        ),
      ],
    );
  }
}
