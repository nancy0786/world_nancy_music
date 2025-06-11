# lib/components/privacy_toggle.dart

import 'package:flutter/material.dart';

class PrivacyToggle extends StatelessWidget {
  final bool isPublic;
  final VoidCallback onToggle;

  const PrivacyToggle({
    super.key,
    required this.isPublic,
    required this.onToggle,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Icon(Icons.lock_open, color: Colors.cyanAccent),
        const SizedBox(width: 10),
        Expanded(
          child: Text(
            isPublic ? 'Public Playlist' : 'Private Playlist',
            style: const TextStyle(color: Colors.white),
          ),
        ),
        Switch(
          value: isPublic,
          onChanged: (_) => onToggle(),
          activeColor: Colors.cyanAccent,
        ),
      ],
    );
  }
}
