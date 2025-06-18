import 'package:world_music_nancy/widgets/neon_aware_container.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CategorySelector extends StatefulWidget {
  const CategorySelector({super.key});

  @override
  State<CategorySelector> createState() => _CategorySelectorState();
}

class _CategorySelectorState extends State<CategorySelector> {
  final List<String> categories = ['cyber', 'girl', 'nature'];
  String selected = 'girl';

  @override
  void initState() {
    super.initState();
    _loadSelection();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: categories.map((cat) {
        return GestureDetector(
          onTap: () => _saveSelection(cat),
          child: NeonAwareContainer(
            margin: const EdgeInsets.symmetric(horizontal: 10),
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
            decoration: BoxDecoration(
              color: selected == cat ? Colors.tealAccent : Colors.white12,
              borderRadius: const BorderRadius.all(Radius.circular(20)), // ✅ const used
            ),
            child: Text(
              cat.toUpperCase(),
              style: const TextStyle(color: Colors.white),
            ),
          ),
        );
      }).toList(),
    );
  }

  Future<void> _loadSelection() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      selected = prefs.getString('backgroundCategory') ?? 'girl';
    });
  }

  Future<void> _saveSelection(String category) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('backgroundCategory', category);
    setState(() {
      selected = category;
    });
  }
}
