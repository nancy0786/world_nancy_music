cat > lib/screens/settings_screen.dart << 'EOF'
import 'package:flutter/material.dart';
import 'package:world_music_nancy/services/storage_service.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  String _selectedTheme = 'neon';
  String _selectedCategory = 'girls';

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  void _loadSettings() async {
    final theme = await StorageService.getThemeMode();
    final category = await StorageService.getBackgroundCategory();
    setState(() {
      _selectedTheme = theme;
      _selectedCategory = category;
    });
  }

  void _saveSettings() async {
    await StorageService.saveThemeMode(_selectedTheme);
    await StorageService.saveBackgroundCategory(_selectedCategory);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Settings saved!")),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text('Settings'),
        backgroundColor: Colors.tealAccent.shade700,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            DropdownButtonFormField(
              value: _selectedTheme,
              dropdownColor: Colors.black,
              decoration: const InputDecoration(labelText: 'Theme Mode', labelStyle: TextStyle(color: Colors.white)),
              items: ['neon', 'dark', 'light'].map((mode) {
                return DropdownMenuItem(value: mode, child: Text(mode, style: const TextStyle(color: Colors.white)));
              }).toList(),
              onChanged: (value) => setState(() => _selectedTheme = value!),
            ),
            const SizedBox(height: 20),
            DropdownButtonFormField(
              value: _selectedCategory,
              dropdownColor: Colors.black,
              decoration: const InputDecoration(labelText: 'Background Category', labelStyle: TextStyle(color: Colors.white)),
              items: ['cyber', 'girls', 'nature'].map((cat) {
                return DropdownMenuItem(value: cat, child: Text(cat, style: const TextStyle(color: Colors.white)));
              }).toList(),
              onChanged: (value) => setState(() => _selectedCategory = value!),
            ),
            const SizedBox(height: 30),
            ElevatedButton.icon(
              icon: const Icon(Icons.save),
              label: const Text("Save Settings"),
              onPressed: _saveSettings,
              style: ElevatedButton.styleFrom(backgroundColor: Colors.purple),
            )
          ],
        ),
      ),
    );
  }
}
EOF
