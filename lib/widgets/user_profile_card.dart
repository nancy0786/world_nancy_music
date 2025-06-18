import 'package:world_music_nancy/widgets/neon_aware_container.dart';
import 'package:world_music_nancy/widgets/neon_aware_card.dart';
import 'package:world_music_nancy/widgets/neon_aware_container.dart';
import 'package:world_music_nancy/widgets/neon_aware_card.dart';
import 'package:flutter/material.dart';

class UserProfileCard extends StatelessWidget {
  final String username;
  final String avatarUrl;

  const UserProfileCard({
    super.key,
    required this.username,
    required this.avatarUrl,
  });

  @override
  Widget build(BuildContext context) {
    return NeonAwareCard(
      color: Colors.black87,
      elevation: 8,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            NeonAwareContainer(
              decoration: BoxDecoration(
                border: Border.all(color: Colors.tealAccent, width: 2),
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.cyanAccent.withOpacity(0.5),
                    blurRadius: 8,
                    spreadRadius: 2,
                  )
                ],
              ),
              child: CircleAvatar(
                backgroundImage: NetworkImage(avatarUrl),
                radius: 30,
              ),
            ),
            const SizedBox(width: 16),
            Text(
              username,
              style: const TextStyle(
                color: Colors.tealAccent,
                fontSize: 20,
                fontWeight: FontWeight.bold,
                shadows: [
                  Shadow(
                    blurRadius: 8,
                    color: Colors.cyanAccent,
                    offset: Offset(1, 1),
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
