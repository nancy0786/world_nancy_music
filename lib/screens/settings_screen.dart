import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:world_music_nancy/providers/preferences_provider.dart';
import 'package:world_music_nancy/widgets/neon_aware_tile.dart';
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
                // TODO: Implement theme switching if needed
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
            const SizedBox(height: 20),

            // UI Style Toggle Section
            const Text(
              '🎨 Interface Style',
              style: TextStyle(color: Colors.cyanAccent, fontSize: 16, fontWeight: FontWeight.bold),
            ),
            RadioListTile<String>(
              title: const Text('Futuristic', style: TextStyle(color: Colors.white)),
              value: 'futuristic',
              groupValue: prefs.uiStyle,
              onChanged: (val) => prefs.setUIStyle(val!),
            ),
            RadioListTile<String>(
              title: const Text('Normal', style: TextStyle(color: Colors.white)),
              value: 'normal',
              groupValue: prefs.uiStyle,
              onChanged: (val) => prefs.setUIStyle(val!),
            ),

            const SizedBox(height: 20),

            // Background Selection
            const Text(
              '🖼️ Background Theme',
              style: TextStyle(color: Colors.cyanAccent, fontSize: 16, fontWeight: FontWeight.bold),
            ),
            RadioListTile<String>(
              title: const Text('Girls', style: TextStyle(color: Colors.white)),
              value: 'girls',
              groupValue: prefs.backgroundCategory,
              onChanged: (val) => prefs.setBackgroundCategory(val!),
            ),
            RadioListTile<String>(
              title: const Text('Cyberpunk', style: TextStyle(color: Colors.white)),
              value: 'cyberpunk',
              groupValue: prefs.backgroundCategory,
              onChanged: (val) => prefs.setBackgroundCategory(val!),
            ),
            RadioListTile<String>(
              title: const Text('Nature', style: TextStyle(color: Colors.white)),
              value: 'nature',
              groupValue: prefs.backgroundCategory,
              onChanged: (val) => prefs.setBackgroundCategory(val!),
            ),
            RadioListTile<String>(
              title: const Text('Dark', style: TextStyle(color: Colors.white)),
              value: 'dark',
              groupValue: prefs.backgroundCategory,
              onChanged: (val) => prefs.setBackgroundCategory(val!),
            ),
          ],
        ),
      ),
    );
  }
}
