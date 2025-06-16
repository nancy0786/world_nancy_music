import 'package:flutter/material.dart';
import 'package:world_music_nancy/components/base_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:world_music_nancy/components/base_screen.dart';
import 'package:world_music_nancy/components/custom_app_bar.dart';
import 'package:world_music_nancy/components/base_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  late TextEditingController _usernameController;
  late TextEditingController _emailController;
  late TextEditingController _bioController;

  @override
  void initState() {
    super.initState();
    _usernameController = TextEditingController();
    _emailController = TextEditingController();
    _bioController = TextEditingController();
    _loadProfile();
  }

  Future<void> _loadProfile() async {
    final prefs = await SharedPreferences.getInstance();
    _usernameController.text = prefs.getString('username') ?? '';
    _emailController.text = prefs.getString('email') ?? '';
    _bioController.text = prefs.getString('bio') ?? '';
  }

  Future<void> _saveProfile() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('username', _usernameController.text);
    await prefs.setString('email', _emailController.text);
    await prefs.setString('bio', _bioController.text);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Profile Saved!')),
    );
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _emailController.dispose();
    _bioController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BaseScreen(child: Scaffold(backgroundColor: Colors.transparent,
      appBar: AppBar(title: const Text("Your Profile")),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: ListView(
          children: [
            TextField(
              controller: _usernameController,
              decoration: const InputDecoration(labelText: "Username"),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _emailController,
              decoration: const InputDecoration(labelText: "Email"),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _bioController,
              decoration: const InputDecoration(labelText: "Bio / Status"),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _saveProfile,
              child: const Text("Save Profile"),
            ),
          ],
        ),
      ),
    );
  }
);
}
