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
import 'package:share_plus/share_plus.dart';

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
  bool _isShuffling = false;
  bool _isRepeating = false;
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
      _player.setLoopMode(LoopMode.off);
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
    final filename = widget.title.replaceAll(RegExp(r'[^\w\s-]'), '_') + ".mp3";
    final path = "${directory.path}/$filename";

    final file = File(path);
    if (file.existsSync()) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("✅ Already downloaded")));
      return;
    }

    try {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("⬇️ Downloading...")));
      final response = await http.get(Uri.parse(widget.url));
      await file.writeAsBytes(response.bodyBytes);

      final prefs = await SharedPreferences.getInstance();
      final downloads = prefs.getStringList('downloaded_songs') ?? [];
      downloads.add('$filename|${widget.title}|${widget.author}');
      await prefs.setStringList('downloaded_songs', downloads);

      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("✅ Download complete")));
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("❌ Download failed")));
    }
  }

  void _shareSong() {
    Share.share("${widget.title} - ${widget.author}\n${widget.url}", subject: "Listen on Nancy Music World");
  }

  void _toggleShuffle() {
    setState(() => _isShuffling = !_isShuffling);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(_isShuffling ? "🔀 Shuffle ON" : "➡️ Shuffle OFF")),
    );
  }

  void _toggleRepeat() {
    setState(() {
      _isRepeating = !_isRepeating;
      _player.setLoopMode(_isRepeating ? LoopMode.one : LoopMode.off);
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(_isRepeating ? "🔁 Repeat ON" : "⏹ Repeat OFF")),
    );
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
    final queue = widget.queue ?? [];
    final current = {'title': widget.title, 'channel': widget.author, 'url': widget.url};

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.black87,
      isScrollControlled: true,
      builder: (_) {
        return DraggableScrollableSheet(
          expand: false,
          initialChildSize: 0.8,
          minChildSize: 0.4,
          maxChildSize: 0.95,
          builder: (_, controller) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  child: Text("🎧 Now Playing Queue", style: TextStyle(color: Colors.white, fontSize: 18)),
                ),
                Expanded(
                  child: ReorderableListView.builder(
                    itemCount: queue.length,
                    onReorder: (oldIndex, newIndex) {
                      setState(() {
                        if (newIndex > oldIndex) newIndex -= 1;
                        final song = queue.removeAt(oldIndex);
                        queue.insert(newIndex, song);
                      });
                    },
                    itemBuilder: (_, i) {
                      final song = queue[i];
                      final isCurrent = song['url'] == current['url'];
                      final videoId = song['url']!.split("v=").last;

                      return ListTile(
                        key: ValueKey(song['url']),
                        leading: Image.network("https://img.youtube.com/vi/$videoId/0.jpg", width: 48),
                        title: Text(song['title'] ?? '', style: TextStyle(color: isCurrent ? Colors.cyanAccent : Colors.white)),
                        subtitle: Text(song['channel'] ?? '', style: const TextStyle(color: Colors.white54)),
                        trailing: const Icon(Icons.drag_handle, color: Colors.white30),
                        onTap: () {
                          Navigator.pop(context);
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (_) => PlayerScreen(
                                title: song['title']!,
                                author: song['channel']!,
                                url: song['url']!,
                                queue: queue,
                              ),
                            ),
                          );
                        },
                      );
                    },
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }

  String _formatTime(Duration d) => d.toString().split('.').first.padLeft(8, "0");

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
                if (_showHeartAnimation) const Icon(Icons.favorite, size: 100, color: Colors.pinkAccent),
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
                  value: _position.inSeconds.clamp(0, _duration.inSeconds).toDouble(),
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
                      icon: Icon(_isShuffling ? Icons.shuffle_on : Icons.shuffle, color: _isShuffling ? Colors.cyanAccent : Colors.white38),
                      onPressed: _toggleShuffle,
                    ),
                    IconButton(icon: const Icon(Icons.skip_previous, color: Colors.cyanAccent, size: 40), onPressed: () {}),
                    IconButton(
                      icon: Icon(_isPlaying ? Icons.pause_circle_filled : Icons.play_circle_fill, size: 64, color: Colors.white),
                      onPressed: _togglePlayback,
                    ),
                    IconButton(icon: const Icon(Icons.skip_next, color: Colors.cyanAccent, size: 40), onPressed: () {}),
                    IconButton(
                      icon: Icon(_isFavorited ? Icons.favorite : Icons.favorite_border,
                          size: 36, color: _isFavorited ? Colors.pinkAccent : Colors.white70),
                      onPressed: _toggleFavorite,
                    ),
                    IconButton(icon: const Icon(Icons.download_rounded, color: Colors.cyanAccent, size: 34), onPressed: _downloadSong),
                    IconButton(icon: const Icon(Icons.share, color: Colors.white70), onPressed: _shareSong),
                    IconButton(
                      icon: Icon(_isRepeating ? Icons.repeat_one : Icons.repeat,
                          color: _isRepeating ? Colors.cyanAccent : Colors.white38),
                      onPressed: _toggleRepeat,
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
