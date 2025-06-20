import 'dart:io';
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:world_music_nancy/components/base_screen.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:world_music_nancy/widgets/neon_aware_container.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:world_music_nancy/screens/lyrics_screen.dart';

class PlayerScreen extends StatefulWidget {
  final String title;
  final String author;
  final String url;
  final List<Map<String, String>>? queue;

  const PlayerScreen({
    super.key,
    required this.title,
    required this.author,
    required this.url,
    this.queue,
  });

  @override
  State<PlayerScreen> createState() => _PlayerScreenState();
}

class _PlayerScreenState extends State<PlayerScreen> {
  late AudioPlayer _player;
  bool _isPlaying = false;
  bool _isFavorited = false;
  bool _showHeartAnimation = false;
  Duration _position = Duration.zero;
  Duration _duration = Duration.zero;

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
      _player.play();
      setState(() => _isPlaying = true);

      _player.durationStream.listen((d) => setState(() => _duration = d ?? Duration.zero));
      _player.positionStream.listen((p) => setState(() => _position = p));
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

  String _formatTime(Duration d) {
    return d.toString().split('.').first.padLeft(8, "0");
  }

  void _openLyrics() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => LyricsScreen(
          title: widget.title,
          artist: widget.author,
          player: _player,
        ),
      ),
    );
  }

  void _openQueue() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.black87,
      builder: (_) {
        final queue = widget.queue ?? [];
        return ListView.builder(
          itemCount: queue.length,
          itemBuilder: (_, i) => ListTile(
            title: Text(queue[i]['title'] ?? '', style: const TextStyle(color: Colors.white)),
            subtitle: Text(queue[i]['channel'] ?? '', style: const TextStyle(color: Colors.white54)),
            onTap: () {
              Navigator.pop(context);
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (_) => PlayerScreen(
                    title: queue[i]['title']!,
                    author: queue[i]['channel']!,
                    url: queue[i]['url']!,
                    queue: queue,
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    _player.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BaseScreen(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: GestureDetector(
          onVerticalDragUpdate: (details) {
            if (details.delta.dy < -10) _openLyrics(); // swipe up
            if (details.delta.dy > 10) Navigator.pop(context); // swipe down
          },
          onHorizontalDragEnd: (_) => _openQueue(), // swipe left
          child: Center(
            child: Column(
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
                  child: const SizedBox.shrink(),
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
                Slider(
                  value: _position.inSeconds.toDouble(),
                  min: 0,
                  max: _duration.inSeconds.toDouble(),
                  onChanged: (val) {
                    _player.seek(Duration(seconds: val.toInt()));
                    setState(() => _position = Duration(seconds: val.toInt()));
                  },
                  activeColor: Colors.cyanAccent,
                  inactiveColor: Colors.white30,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 30.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(_formatTime(_position), style: const TextStyle(color: Colors.white54)),
                      Text(_formatTime(_duration), style: const TextStyle(color: Colors.white54)),
                    ],
                  ),
                ),
                const SizedBox(height: 12),
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
                const Text("⬆️ Scroll up for lyrics, ⬅️ for queue, ⬇️ to exit", style: TextStyle(color: Colors.white54, fontSize: 12)),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
