import 'package:flutter/material.dart';
import 'package:world_music_nancy/components/base_screen.dart';
import 'package:world_music_nancy/services/youtube_service.dart';
import 'package:world_music_nancy/components/base_screen.dart';
import 'package:world_music_nancy/screens/player_screen.dart';
import 'package:world_music_nancy/components/base_screen.dart';
import 'package:world_music_nancy/components/custom_app_bar.dart';
import 'package:world_music_nancy/components/base_screen.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _controller = TextEditingController();
  List<Map<String, String>> _results = [];
  bool _isLoading = false;

  Future<void> _search(String query) async {
    setState(() => _isLoading = true);
    final results = await YouTubeService.search(query);
    setState(() {
      _results = results;
      _isLoading = false;
    });
  }

  Future<void> _play(String videoId, String title) async {
    final data = await YouTubeService.getAudioStream(videoId);
    if (data == null) return;

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => PlayerScreen(
          title: data['title']!,
          author: 'YouTube',
          url: data['url']!,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
