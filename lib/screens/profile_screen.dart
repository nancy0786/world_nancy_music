import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:world_music_nancy/components/base_screen.dart';
import 'package:world_music_nancy/components/custom_app_bar.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  String name = '';
  String email = '';
  String bio = '';
  String avatarPath = '';
  bool editingName = false;
  bool editingBio = false;

  final TextEditingController nameController = TextEditingController();
  final TextEditingController bioController = TextEditingController();

  final List<String> avatarOptions = [
    'assets/avatars/avatar1.png',
    'assets/avatars/avatar2.png',
    'assets/avatars/avatar3.png',
    'assets/avatars/avatar4.png',
  ];

  @override
  void initState() {
    super.initState();
    loadProfile();
  }

  Future<void> loadProfile() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      name = prefs.getString('username') ?? '';
      email = prefs.getString('email') ?? 'nancy@example.com';
      bio = prefs.getString('bio') ?? '';
      avatarPath = prefs.getString('avatar') ?? '';
      nameController.text = name;
      bioController.text = bio;
    });
  }

  Future<void> saveProfile() async {
    final prefs = await SharedPreferences.getInstance();
    if (nameController.text.trim().isNotEmpty) {
      await prefs.setString('username', nameController.text.trim());
      setState(() => name = nameController.text.trim());
    }
    await prefs.setString('bio', bioController.text.trim());
    setState(() => bio = bioController.text.trim());

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('✅ Profile updated!')),
    );
  }

  Future<void> saveAvatar(String path) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('avatar', path);
    setState(() => avatarPath = path);
  }

  String getGreeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) return 'Good Morning';
    if (hour < 17) return 'Good Afternoon';
    if (hour < 20) return 'Good Evening';
    return 'Good Night';
  }

  void showAvatarPicker() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.black87,
      builder: (_) {
        return GridView.count(
          crossAxisCount: 3,
          padding: const EdgeInsets.all(16),
          children: avatarOptions.map((avatar) {
            return GestureDetector(
              onTap: () {
                saveAvatar(avatar);
                Navigator.pop(context);
              },
              child: Padding(
                padding: const EdgeInsets.all(8),
                child: CircleAvatar(
                  radius: 40,
                  backgroundImage: AssetImage(avatar),
                ),
              ),
            );
          }).toList(),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return BaseScreen(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: const CustomAppBar(title: 'Profile'),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              /// Avatar
              Stack(
                children: [
                  CircleAvatar(
                    radius: 45,
                    backgroundImage: avatarPath.isNotEmpty
                        ? AssetImage(avatarPath)
                        : const AssetImage('assets/avatars/avatar1.png'),
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: IconButton(
                      icon: const Icon(Icons.edit, color: Colors.pinkAccent),
                      onPressed: showAvatarPicker,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 10),
              Text(
                '${getGreeting()}, ${name.isNotEmpty ? name : "User"}',
                style: const TextStyle(
                  fontSize: 16,
                  color: Color(0xFF00FFFF),
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 30),

              /// Name
              Row(
                children: [
                  Expanded(
                    child: editingName
                        ? TextField(
                            controller: nameController,
                            style: const TextStyle(color: Colors.white),
                            decoration: const InputDecoration(
                              hintText: 'Enter your name',
                              hintStyle: TextStyle(color: Colors.white38),
                              enabledBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.white24),
                              ),
                            ),
                          )
                        : Text(
                            name.isNotEmpty ? name : 'No name set',
                            style: const TextStyle(fontSize: 15, color: Colors.white),
                          ),
                  ),
                  IconButton(
                    icon: Icon(editingName ? Icons.check : Icons.edit, color: Colors.pinkAccent),
                    onPressed: () {
                      if (editingName && nameController.text.trim().isNotEmpty) {
                        saveProfile();
                      }
                      setState(() => editingName = !editingName);
                    },
                  ),
                ],
              ),

              const SizedBox(height: 10),

              /// Email
              Row(
                children: [
                  const Icon(Icons.email, size: 16, color: Colors.cyanAccent),
                  const SizedBox(width: 8),
                  Text(
                    email,
                    style: const TextStyle(fontSize: 13, color: Colors.white70),
                  ),
                ],
              ),

              const SizedBox(height: 20),

              /// Bio
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: editingBio
                        ? TextField(
                            controller: bioController,
                            style: const TextStyle(color: Colors.white),
                            maxLines: 2,
                            decoration: const InputDecoration(
                              hintText: 'Add something cool (optional)',
                              hintStyle: TextStyle(color: Colors.white54),
                              enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.white24),
                              ),
                            ),
                          )
                        : Text(
                            bio.isNotEmpty ? bio : 'No bio added',
                            style: const TextStyle(fontSize: 13, color: Colors.white70),
                          ),
                  ),
                  IconButton(
                    icon: Icon(editingBio ? Icons.check : Icons.edit, color: Colors.pinkAccent),
                    onPressed: () {
                      if (editingBio) saveProfile();
                      setState(() => editingBio = !editingBio);
                    },
                  ),
                ],
              ),

              const SizedBox(height: 30),

              /// Settings Button
              ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.pinkAccent,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                icon: const Icon(Icons.settings, color: Colors.black),
                label: const Text(
                  'Open Settings',
                  style: TextStyle(color: Colors.black),
                ),
                onPressed: () {
                  // TODO: Implement settings navigation
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
