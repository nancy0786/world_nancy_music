import 'package:world_music_nancy/widgets/neon_aware_tile.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CustomDrawer extends StatelessWidget {
  final VoidCallback onThemeToggle;

  const CustomDrawer({super.key, required this.onThemeToggle});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Colors.black87,
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [Colors.purpleAccent, Colors.cyanAccent],
              ),
            ),
            child: Align(
              alignment: Alignment.bottomLeft,
              child: Text(
                'Nancy Music World',
                style: GoogleFonts.orbitron(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                  shadows: [
                    Shadow(
                      color: Colors.white54,
                      offset: Offset(1, 1),
                      blurRadius: 3,
                    )
                  ],
                ),
              ),
            ),
          ),
          NeonAwareTile(
            leading: const Icon(Icons.brightness_6, color: Colors.cyanAccent),
            title: const Text(
              'Toggle Theme',
              style: TextStyle(color: Colors.white),
            ),
            onTap: onThemeToggle,
          ),
          NeonAwareTile(
            leading: const Icon(Icons.info_outline, color: Colors.tealAccent),
            title: const Text(
              'About App',
              style: TextStyle(color: Colors.white),
            ),
            onTap: () {
              showAboutDialog(
                context: context,
                applicationName: 'Nancy Music World',
                applicationVersion: '1.0.0',
                applicationLegalese: '© 2025 Nancy Music Dev Team',
                children: const [
                  Padding(
                    padding: EdgeInsets.only(top: 10),
                    child: Text(
                      'A futuristic music player powered by YouTube audio and neon UI.\n\nBuilt for immersive listening with playlist sync, dark mode, and cyberpunk design.',
                      style: TextStyle(fontSize: 14),
                    ),
                  ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}
