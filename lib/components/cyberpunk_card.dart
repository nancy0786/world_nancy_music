import 'package:world_music_nancy/widgets/neon_aware_tile.dart';
import 'package:world_music_nancy/widgets/neon_aware_card.dart';
import 'package:world_music_nancy/widgets/neon_aware_tile.dart';
import 'package:world_music_nancy/widgets/neon_aware_card.dart';

import 'package:flutter/material.dart';

class CyberpunkCard extends StatelessWidget {
  final String title;
  final String? subtitle;
  final IconData icon;
  final VoidCallback onTap;

  const CyberpunkCard({
    super.key,
    required this.title,
    this.subtitle,
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return NeonAwareCard(
      color: Colors.black,
      shape: RoundedRectangleBorder(
        side: const BorderSide(color: Colors.deepPurpleAccent, width: 2),
        borderRadius: BorderRadius.circular(16),
      ),
      elevation: 8,
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: NeonAwareTile(
        leading: Icon(
          icon,
          color: Colors.deepPurpleAccent,
          size: 30,
        ),
        title: Text(
          title,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        subtitle: subtitle != null
            ? Text(
                subtitle!,
                style: const TextStyle(color: Colors.white70),
              )
            : null,
        onTap: onTap,
      ),
    );
  }
}
