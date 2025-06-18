import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:world_music_nancy/providers/preferences_provider.dart';
import 'package:world_music_nancy/widgets/neon_aware_tile.dart';
import 'package:world_music_nancy/widgets/option_preview_tile.dart';
import 'package:world_music_nancy/components/base_screen.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final prefs = Provider.of<PreferencesProvider>(context);

    return BaseScreen(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          title: const Text('Settings'),
          backgroundColor: Colors.black,
        ),
        body: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            NeonAwareTile(
              title: const Text("Theme"),
              subtitle: const Text("Switch between neon, dark and light"),
              trailing: const Icon(Icons.color_lens),
              onTap: () {
                // TODO: Implement if needed
              },
            ),
            NeonAwareTile(
              title: const Text("Clear Cache"),
              trailing: const Icon(Icons.delete),
              onTap: () {
                // TODO: Clear cache logic
              },
            ),
            NeonAwareTile(
              title: const Text("App Info"),
              trailing: const Icon(Icons.info_outline),
              onTap: () {
                showAboutDialog(
                  context: context,
                  applicationName: "Nancy Music World",
                  applicationVersion: "1.0.0",
                  applicationLegalese: "© 2025 Nancy Corp.",
                );
              },
            ),

            const SizedBox(height: 30),
            const Text(
              '🎨 Interface Style',
              style: TextStyle(color: Colors.cyanAccent, fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  OptionPreviewTile(
                    label: "Futuristic",
                    imagePath: 'assets/previews/futuristic_style.png',
                    selected: prefs.uiStyle == 'futuristic',
                    onTap: () => prefs.setUIStyle('futuristic'),
                  ),
                  OptionPreviewTile(
                    label: "Normal",
                    imagePath: 'assets/previews/normal_style.png',
                    selected: prefs.uiStyle == 'normal',
                    onTap: () => prefs.setUIStyle('normal'),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 30),
            const Text(
              '🖼️ Background Theme',
              style: TextStyle(color: Colors.cyanAccent, fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  OptionPreviewTile(
                    label: "Girls",
                    imagePath: 'assets/previews/girls_preview.jpg',
                    selected: prefs.backgroundCategory == 'girls',
                    onTap: () => prefs.setBackgroundCategory('girls'),
                  ),
                  OptionPreviewTile(
                    label: "Cyberpunk",
                    imagePath: 'assets/previews/cyberpunk_preview.jpg',
                    selected: prefs.backgroundCategory == 'cyberpunk',
                    onTap: () => prefs.setBackgroundCategory('cyberpunk'),
                  ),
                  OptionPreviewTile(
                    label: "Nature",
                    imagePath: 'assets/previews/nature_preview.jpg',
                    selected: prefs.backgroundCategory == 'nature',
                    onTap: () => prefs.setBackgroundCategory('nature'),
                  ),
                  OptionPreviewTile(
                    label: "Dark",
                    imagePath: 'assets/previews/dark_preview.jpg',
                    selected: prefs.backgroundCategory == 'dark',
                    onTap: () => prefs.setBackgroundCategory('dark'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
