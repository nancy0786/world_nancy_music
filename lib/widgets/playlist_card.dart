import 'package:flutter/material.dart';

class PlaylistCard extends StatelessWidget {
  final String title;
  final String image;
  final VoidCallback onTap;

  const PlaylistCard({
    super.key,
    required this.title,
    required this.image,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Stack(
          children: [
            Image.asset(
              image,
              width: 160,
              height: 160,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) => Container(
                width: 160,
                height: 160,
                color: Colors.grey[800],
                child: const Icon(Icons.music_note, color: Colors.white70, size: 50),
              ),
            ),
            Container(
              width: 160,
              height: 160,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Colors.black.withOpacity(0.6),
                    Colors.transparent,
                  ],
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                ),
              ),
            ),
            Positioned(
              bottom: 10,
              left: 10,
              right: 10,
              child: Text(
                title,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
