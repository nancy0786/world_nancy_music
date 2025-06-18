import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:world_music_nancy/components/base_screen.dart';
import 'package:world_music_nancy/components/custom_app_bar.dart';
import 'package:world_music_nancy/screens/settings_screen.dart';
import 'package:world_music_nancy/components/settings_tile.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  late TextEditingController _usernameController;
  late TextEditingController _bioController;
  late TextEditingController _emailController;

  bool _editingName = false;
  bool _editingBio = false;

  String greeting = '';
  String? selectedAvatar;

  @override
  void initState() {
    super.initState();
    _usernameController = TextEditingController();
    _bioController = TextEditingController();
    _emailController = TextEditingController();
    _loadProfile();
    _setGreeting();
  }

  void _setGreeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) {
      greeting = 'Good Morning ☀️';
    } else if (hour < 18) {
      greeting = 'Good Afternoon 🌞';
    } else {
      greeting = 'Good Evening 🌙';
    }
  }

  Future<void> _loadProfile() async {
    final prefs = await SharedPreferences.getInstance();
    _usernameController.text = prefs.getString('username') ?? '';
    _emailController.text = prefs.getString('email') ?? '';
    _bioController.text = prefs.getString('bio') ?? '';
    selectedAvatar = prefs.getString('avatar');
    setState(() {});
  }

  Future<void> _saveProfile() async {
    final prefs = await SharedPreferences.getInstance();
    if (_usernameController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Name cannot be empty.")),
      );
      return;
    }
    await prefs.setString('username', _usernameController.text.trim());
    await prefs.setString('bio', _bioController.text.trim());
    await prefs.setString('email', _emailController.text.trim());
    if (selectedAvatar != null) {
      await prefs.setString('avatar', selectedAvatar!);
    }
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('✅ Profile Saved!')),
    );
    setState(() {
      _editingName = false;
      _editingBio = false;
    });
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _bioController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  void _chooseAvatar() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.black87,
      builder: (_) {
        return GridView.count(
          crossAxisCount: 4,
          padding: const EdgeInsets.all(12),
          children: List.generate(8, (index) {
            final avatar = 'assets/avatars/avatar${index + 1}.png';
            return GestureDetector(
              onTap: () {
                setState(() => selectedAvatar = avatar);
                Navigator.pop(context);
              },
              child: CircleAvatar(
                backgroundImage: AssetImage(avatar),
                radius: 30,
              ),
            );
          }),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return BaseScreen(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: const CustomAppBar(title: 'Your Profile'),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              const SizedBox(height: 20),
              CircleAvatar(
                radius: 45,
                backgroundImage: selectedAvatar != null
                    ? AssetImage(selectedAvatar!)
                    : const AssetImage('assets/avatars/default.png'),
                backgroundColor: Colors.grey[800],
              ),
              TextButton(
                onPressed: _chooseAvatar,
                child: const Text(
                  'Choose Avatar',
                  style: TextStyle(color: Colors.cyanAccent),
                ),
              ),
              const SizedBox(height: 10),
              Text(
                greeting,
                style: const TextStyle(
                  fontSize: 16,
                  color: Colors.cyanAccent,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _usernameController,
                      enabled: _editingName,
                      style: const TextStyle(color: Colors.white),
                      decoration: const InputDecoration(
                        labelText: 'Name',
                        labelStyle: TextStyle(color: Colors.white70),
                        enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.white24),
                        ),
                      ),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.edit, color: Colors.white54),
                    onPressed: () {
                      setState(() => _editingName = !_editingName);
                    },
                  ),
                ],
              ),
              const SizedBox(height: 10),
              TextField(
                controller: _emailController,
                enabled: false,
                style: const TextStyle(color: Colors.white54),
                decoration: const InputDecoration(
                  labelText: 'Email ID',
                  labelStyle: TextStyle(color: Colors.white38),
                ),
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _bioController,
                      maxLines: 2,
                      enabled: _editingBio,
                      style: const TextStyle(color: Colors.white),
                      decoration: const InputDecoration(
                        labelText: 'Bio (optional)',
                        labelStyle: TextStyle(color: Colors.white70),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.white24),
                        ),
                      ),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.edit, color: Colors.white54),
                    onPressed: () {
                      setState(() => _editingBio = !_editingBio);
                    },
                  ),
                ],
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _saveProfile,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.pinkAccent,
                  padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 12),
                ),
                child: const Text('Save Changes'),
              ),
              const SizedBox(height: 30),
              SettingsTile(
                icon: Icons.settings,
                title: 'Open Settings',
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const SettingsScreen()),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
