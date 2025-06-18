import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:world_music_nancy/providers/preferences_provider.dart';

class AppearanceSettingsScreen extends StatelessWidget {
  const AppearanceSettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final prefs = Provider.of<PreferencesProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Appearance Settings'),
        backgroundColor: Colors.black,
      ),
      backgroundColor: Colors.black87,
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          const Text(
            "🔧 UI Style",
            style: TextStyle(fontSize: 18, color: Colors.cyanAccent),
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 12,
            children: [
              ChoiceChip(
                label: const Text('Futuristic'),
                selected: prefs.isFuturistic,
                onSelected: (_) => prefs.setUIStyle('futuristic'),
                selectedColor: Colors.pinkAccent,
              ),
              ChoiceChip(
                label: const Text('Normal'),
                selected: prefs.isNormal,
                onSelected: (_) => prefs.setUIStyle('normal'),
                selectedColor: Colors.blueGrey,
              ),
            ],
          ),
          const SizedBox(height: 24),
          const Text(
            "🎞️ Background Category",
            style: TextStyle(fontSize: 18, color: Colors.cyanAccent),
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 12,
            children: [
              ChoiceChip(
                label: const Text('Girls'),
                selected: prefs.isGirlsBG,
                onSelected: (_) => prefs.setBackgroundCategory('girls'),
              ),
              ChoiceChip(
                label: const Text('Cyberpunk'),
                selected: prefs.isCyberpunkBG,
                onSelected: (_) => prefs.setBackgroundCategory('cyberpunk'),
              ),
              ChoiceChip(
                label: const Text('Nature'),
                selected: prefs.isNatureBG,
                onSelected: (_) => prefs.setBackgroundCategory('nature'),
              ),
              ChoiceChip(
                label: const Text('Dark'),
                selected: prefs.isDarkBG,
                onSelected: (_) => prefs.setBackgroundCategory('dark'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
