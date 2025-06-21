import 'dart:async';
import 'package:flutter/material.dart';
import 'package:world_music_nancy/services/youtube_service.dart';
import 'package:world_music_nancy/services/storage_service.dart';

class AppBotService {
  static final AppBotService _instance = AppBotService._internal();
  factory AppBotService() => _instance;
  AppBotService._internal();

  bool _running = false;
  BuildContext? _context;
  Timer? _timer;

  void start(BuildContext context) {
    if (_running) return;
    _running = true;
    _context = context;
    print("🤖 App Bot Started");
    _startBotLoop();
  }

  void stop() {
    _running = false;
    _timer?.cancel();
    print("🛑 App Bot Stopped");
  }

  void _startBotLoop() {
    _timer = Timer.periodic(const Duration(seconds: 20), (_) async {
      if (!_running) return;
      print("🔁 App Bot Tick");

      // 1. Autoplay recommendations from user mood
      final mood = await _getMood();
      print("🎭 Mood detected: $mood");
      final moodSongs = await YouTubeService.search("$mood music playlist");
      if (moodSongs.isNotEmpty) {
        _notify("New mood playlist: ${moodSongs[0]['title']}");
      }

      // 2. Suggest based on history
      final history = await StorageService.getHistory();
      if (history.isNotEmpty) {
        final recent = history.first['title'];
        final suggest = await YouTubeService.search("Songs like $recent");
        if (suggest.isNotEmpty) {
          _notify("🎶 You might also like: ${suggest[0]['title']}");
        }
      }

      // 3. Discover new trending playlist
      final trending = await YouTubeService.search("Top trending music India");
      if (trending.isNotEmpty) {
        _notify("🔥 Trending now: ${trending[0]['title']}");
      }
    });
  }

  Future<String> _getMood() async {
    // You can later make this dynamic based on time, weather, etc.
    final moods = ["Romantic", "Lo-Fi", "Sad", "Workout", "Focus", "Travel"];
    moods.shuffle();
    return moods.first;
  }

  void _notify(String message) {
    if (_context == null) return;
    final messenger = ScaffoldMessenger.of(_context!);
    messenger.showSnackBar(SnackBar(
      content: Text("🤖 $message"),
      backgroundColor: Colors.purpleAccent,
      duration: const Duration(seconds: 5),
    ));
  }
}
