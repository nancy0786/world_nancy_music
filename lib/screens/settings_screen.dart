import 'package:flutter/material.dart';
import 'package:world_music_nancy/components/base_screen.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:world_music_nancy/components/base_screen.dart';
import 'package:nancy_music_world/utils/constants.dart';
import 'package:world_music_nancy/components/base_screen.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BaseScreen(child: Scaffold(backgroundColor: Colors.transparent,
      backgroundColor: AppColors.darkBackground,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          'Settings',
          style: GoogleFonts.orbitron(
            fontSize: 22,
            color: AppColors.neonBlue,
            fontWeight: FontWeight.bold,
          ),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: ListView(
        children: [
          ListTile(
            leading: const Icon(Icons.color_lens, color: AppColors.neonPink),
            title: const Text(
              'Theme',
              style: TextStyle(color: Colors.white),
            ),
            onTap: () {
              // TODO: Implement theme toggle
            },
          ),
          ListTile(
            leading: const Icon(Icons.download_for_offline, color: AppColors.neonPurple),
            title: const Text(
              'Manage Downloads',
              style: TextStyle(color: Colors.white),
            ),
            onTap: () {
              // TODO: Navigate to downloads manager
            },
          ),
          ListTile(
            leading: const Icon(Icons.info_outline, color: AppColors.neonBlue),
            title: const Text(
              'About',
              style: TextStyle(color: Colors.white),
            ),
            onTap: () {
              showAboutDialog(
                context: context,
                applicationName: "Nancy Music World",
                applicationVersion: "1.0.0",
                applicationLegalese: "© 2025 Nancy Universe",
              );
            },
          ),
        ],
      ),
    );
  }
);
}
