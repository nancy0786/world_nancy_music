import 'package:world_music_nancy/widgets/neon_aware_tile.dart';
import 'package:world_music_nancy/widgets/neon_aware_tile.dart';
import 'package:flutter/material.dart';
import 'package:world_music_nancy/components/base_screen.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:world_music_nancy/utils/constants.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BaseScreen(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          title: const Text('Settings'),
          backgroundColor: Colors.black,
        ),
        body: ListView(
          children: [
            NeonAwareTile(
              title: const Text("Theme"),
              subtitle: const Text("Switch between neon, dark and light"),
              trailing: Icon(Icons.color_lens),
              onTap: () {
                // Handle theme switching
              },
            ),
            NeonAwareTile(
              title: const Text("Clear Cache"),
              trailing: Icon(Icons.delete),
              onTap: () {
                // Clear cache functionality
              },
            ),
            NeonAwareTile(
              title: const Text("App Info"),
              trailing: Icon(Icons.info_outline),
              onTap: () {
                showAboutDialog(
                  context: context,
                  applicationName: "Nancy Music World",
                  applicationVersion: "1.0.0",
                  applicationLegalese: "© 2025 Nancy Corp.",
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
