#!/bin/bash

# Recreate lib/models/song_model.dart
mkdir -p lib/models
cat > lib/models/song_model.dart << 'EOF'
class SongModel {
  final String title;
  final String url;
  final String channel;
  final String id;

  SongModel({
    required this.title,
    required this.url,
    required this.channel,
    required this.id,
  });
}
EOF

# Recreate lib/models/playlist_model.dart
cat > lib/models/playlist_model.dart << 'EOF'
import 'song_model.dart';

class PlaylistModel {
  final String name;
  final List<SongModel> songs;

  PlaylistModel({required this.name, required this.songs});
}
EOF

# Recreate lib/widgets/thumbnail.dart (YouTubeThumbnail)
mkdir -p lib/widgets
cat > lib/widgets/thumbnail.dart << 'EOF'
import 'package:flutter/material.dart';

class YouTubeThumbnail extends StatelessWidget {
  final String videoId;

  const YouTubeThumbnail({
    super.key,
    required this.videoId,
  });

  @override
  Widget build(BuildContext context) {
    final String thumbnailUrl = 'https://img.youtube.com/vi/\$videoId/0.jpg';

    return ClipRRect(
      borderRadius: const BorderRadius.all(Radius.circular(8)),
      child: Image.network(
        thumbnailUrl,
        fit: BoxFit.cover,
        width: 100,
        height: 56,
        errorBuilder: (context, error, stackTrace) => const Icon(
          Icons.error,
          color: Colors.red,
        ),
      ),
    );
  }
}
EOF

# Recreate missing screen files with dummy content
mkdir -p lib/screens

for screen in login_screen register_screen playlist_details_screen; do
cat > lib/screens/${screen}.dart << 'EOF'
import 'package:flutter/material.dart';

class DummyScreen extends StatelessWidget {
  const DummyScreen({super.key});

  @override
  Widget build(BuildContext context) => const Scaffold(
    body: Center(child: Text('This is a placeholder screen')),
  );
}
EOF
done
