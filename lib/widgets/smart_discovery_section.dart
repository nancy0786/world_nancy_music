import 'package:flutter/material.dart';

class SmartDiscoverySection extends StatelessWidget {
  const SmartDiscoverySection({super.key});

  @override
  Widget build(BuildContext context) {
    final trending = ['Tum Mile', 'Leja Re', 'Kesariya'];
    final mostPlayed = ['Believer', 'Apna Bana Le', 'Vaaste'];
    final topPublic = ['Lo-Fi Chill Mix', 'Workout Boost', 'Desi Beats'];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildCategory("🔥 Trending Now", trending, context),
          _buildCategory("🎶 Most Played", mostPlayed, context),
          _buildCategory("🌟 Top Public Playlists", topPublic, context),
        ],
      ),
    );
  }

  Widget _buildCategory(String title, List<String> songs, BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 14.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.cyanAccent,
              shadows: [
                Shadow(
                  blurRadius: 4,
                  color: Colors.tealAccent,
                  offset: Offset(1, 1),
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),
          Wrap(
            spacing: 12,
            runSpacing: 8,
            children: songs.map((song) {
              return ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black.withOpacity(0.6),
                  foregroundColor: Colors.tealAccent,
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  elevation: 4,
                ),
                onPressed: () {
                  Navigator.pushNamed(context, '/search', arguments: song);
                },
                child: Text(
                  song,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}
