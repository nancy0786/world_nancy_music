import 'dart:io';
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:world_music_nancy/components/base_screen.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:world_music_nancy/widgets/neon_aware_container.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';

class PlayerScreen extends StatefulWidget {
  final String title;
  final String author;
  final String url;

  const PlayerScreen({
    super.key,
    required this.title,
    required this.author,
    required this.url,
  });

  @override
  State<PlayerScreen> createState() => _PlayerScreenState();
}

class _PlayerScreenState extends State<PlayerScreen> {
  late AudioPlayer _player;
  bool _isPlaying = false;
  bool _isFavorited = false;
  bool _showHeartAnimation = false;
  PageController _pageController = PageController();

  @override
  void initState() {
    super.initState();
    _player = AudioPlayer();
    _loadFavoriteStatus();
    _initPlayer();
  }

  Future<void> _initPlayer() async {
    try {
      await _player.setUrl(widget.url);
      await _player.play();
      setState(() => _isPlaying = true);
    } catch (e) {
      debugPrint("Audio error: $e");
    }
  }

  Future<void> _loadFavoriteStatus() async {
    final prefs = await SharedPreferences.getInstance();
    final favorites = prefs.getStringList('favorites_list') ?? [];
    setState(() => _isFavorited = favorites.contains(widget.url));
  }

  Future<void> _toggleFavorite() async {
    final prefs = await SharedPreferences.getInstance();
    final favorites = prefs.getStringList('favorites_list') ?? [];

    if (_isFavorited) {
      favorites.remove(widget.url);
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("❌ Removed from favorites")));
    } else {
      favorites.add(widget.url);
      setState(() => _showHeartAnimation = true);
      Future.delayed(const Duration(seconds: 1), () => setState(() => _showHeartAnimation = false));
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("❤️ Added to favorites")));
    }

    await prefs.setStringList('favorites_list', favorites);
    setState(() => _isFavorited = !_isFavorited);
  }

  void _togglePlayback() async {
    if (_player.playing) {
      await _player.pause();
    } else {
      await _player.play();
    }
    setState(() => _isPlaying = _player.playing);
  }

  Future<void> _downloadSong() async {
    final directory = await getApplicationDocumentsDirectory();
    final filename = widget.title.replaceAll(' ', '_') + ".mp3";
    final path = "${directory.path}/$filename";

    try {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("⬇️ Song download started...")));

      final response = await http.get(Uri.parse(widget.url));
      final file = File(path);
      await file.writeAsBytes(response.bodyBytes);

      final prefs = await SharedPreferences.getInstance();
      final downloads = prefs.getStringList('downloaded_songs') ?? [];
      downloads.add('$filename|${widget.title}|${widget.author}');
      await prefs.setStringList('downloaded_songs', downloads);

      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("✅ Song downloaded!")));
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("❌ Download failed")));
    }
  }

  @override
  void dispose() {
    _player.dispose();
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BaseScreen(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: GestureDetector(
          onVerticalDragEnd: (_) => Navigator.pop(context),
          child: PageView(
            controller: _pageController,
            scrollDirection: Axis.vertical,
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (_showHeartAnimation)
                    const Icon(Icons.favorite, size: 100, color: Colors.pinkAccent),
                  NeonAwareContainer(
                    width: 240,
                    height: 240,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: Colors.cyanAccent, width: 2),
                      boxShadow: [BoxShadow(color: Colors.pinkAccent.withOpacity(0.4), blurRadius: 20)],
                      image: DecorationImage(
                        image: NetworkImage("https://img.youtube.com/vi/${widget.url.split("v=").last}/0.jpg"),
                        fit: BoxFit.cover,
                      ),
                    ),
                    child: const SizedBox.shrink(), // ✅ Error 8 FIXED
                  ),
                  const SizedBox(height: 30),
                  Text(widget.title,
                      textAlign: TextAlign.center,
                      style: GoogleFonts.orbitron(
                        fontSize: 22,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        shadows: [const Shadow(color: Colors.cyanAccent, blurRadius: 6)],
                      )),
                  const SizedBox(height: 6),
                  Text(widget.author,
                      style: GoogleFonts.orbitron(
                        fontSize: 14,
                        color: Colors.white70,
                        letterSpacing: 1.2,
                      )),
                  const SizedBox(height: 30),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.skip_previous, color: Colors.cyanAccent, size: 40),
                        onPressed: () {},
                      ),
                      IconButton(
                        icon: Icon(
                          _isPlaying ? Icons.pause_circle_filled : Icons.play_circle_fill,
                          size: 64,
                          color: Colors.white,
                        ),
                        onPressed: _togglePlayback,
                      ),
                      IconButton(
                        icon: const Icon(Icons.skip_next, color: Colors.cyanAccent, size: 40),
                        onPressed: () {},
                      ),
                      const SizedBox(width: 16),
                      IconButton(
                        icon: Icon(
                          _isFavorited ? Icons.favorite : Icons.favorite_border,
                          size: 36,
                          color: _isFavorited ? Colors.pinkAccent : Colors.white70,
                        ),
                        onPressed: _toggleFavorite,
                      ),
                      IconButton(
                        icon: const Icon(Icons.download_rounded, color: Colors.cyanAccent, size: 34),
                        onPressed: _downloadSong,
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  const Text("⬆️ Scroll up for lyrics, ⬅️ for queue", style: TextStyle(color: Colors.white54, fontSize: 12)),
                ],
              ),
              const Center(
                child: Padding(
                  padding: EdgeInsets.all(24),
                  child: Text(
                    '🎶 Lyrics will appear here...\n(Coming Soon)',
                    style: TextStyle(color: Colors.white70, fontSize: 16),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
