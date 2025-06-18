import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:world_music_nancy/providers/preferences_provider.dart';

class NeonThemeSwitcher extends StatelessWidget {
  const NeonThemeSwitcher({super.key});

  @override
  Widget build(BuildContext context) {
    final prefs = Provider.of<PreferencesProvider>(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text("🧬 Interface Style", style: TextStyle(color: Colors.white70)),
        const SizedBox(height: 8),
        Wrap(
          spacing: 12,
          children: [
            ChoiceChip(
              label: const Text("Futuristic"),
              selected: prefs.isFuturistic,
              onSelected: (_) => prefs.setUIStyle("futuristic"),
              selectedColor: Colors.pinkAccent,
            ),
            ChoiceChip(
              label: const Text("Normal"),
              selected: prefs.isNormal,
              onSelected: (_) => prefs.setUIStyle("normal"),
              selectedColor: Colors.cyan,
            ),
          ],
        ),
        const SizedBox(height: 20),
        const Text("🌌 Background Style", style: TextStyle(color: Colors.white70)),
        const SizedBox(height: 8),
        Wrap(
          spacing: 10,
          children: [
            _chip(context, "Girls", prefs.backgroundCategory == "girls", () => prefs.setBackgroundCategory("girls")),
            _chip(context, "Cyberpunk", prefs.backgroundCategory == "cyberpunk", () => prefs.setBackgroundCategory("cyberpunk")),
            _chip(context, "Nature", prefs.backgroundCategory == "nature", () => prefs.setBackgroundCategory("nature")),
            _chip(context, "Dark", prefs.backgroundCategory == "dark", () => prefs.setBackgroundCategory("dark")),
          ],
        ),
      ],
    );
  }

  Widget _chip(BuildContext context, String label, bool selected, VoidCallback onTap) {
    return ChoiceChip(
      label: Text(label),
      selected: selected,
      onSelected: (_) => onTap(),
      selectedColor: Colors.amberAccent,
      backgroundColor: Colors.grey.shade800,
    );
  }
}
