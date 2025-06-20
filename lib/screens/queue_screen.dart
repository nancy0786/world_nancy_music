import 'package:flutter/material.dart';
import 'package:world_music_nancy/screens/player_screen.dart';
import 'package:just_audio/just_audio.dart';

class QueueScreen extends StatefulWidget {
  final List<Map<String, String>> queue;
  final List<Map<String, String>> upNext;
  final Map<String, String> currentSong;
  final String? playlistName;
  final AudioPlayer player;

  const QueueScreen({
    super.key,
    required this.queue,
    required this.upNext,
    required this.currentSong,
    required this.player,
    this.playlistName,
  });

  @override
  State<QueueScreen> createState() => _QueueScreenState();
}

class _QueueScreenState extends State<QueueScreen> {
  late List<Map<String, String>> currentQueue;
  late List<Map<String, String>> upNextQueue;

  @override
  void initState() {
    super.initState();
    currentQueue = List<Map<String, String>>.from(widget.queue);
    upNextQueue = List<Map<String, String>>.from(widget.upNext);
  }

  void _onReorder(List<Map<String, String>> list, int oldIndex, int newIndex) {
    if (newIndex > oldIndex) newIndex -= 1;
    final item = list.removeAt(oldIndex);
    list.insert(newIndex, item);
    setState(() {});
  }

  Widget _buildSongTile(Map<String, String> song, bool isCurrent, VoidCallback onTap) {
    return ListTile(
      leading: isCurrent
          ? const Icon(Icons.volume_up, color: Colors.cyanAccent)
          : const Icon(Icons.music_note, color: Colors.white70),
      title: Text(
        song['title'] ?? 'Unknown',
        style: TextStyle(
          color: isCurrent ? Colors.cyanAccent : Colors.white,
          fontWeight: isCurrent ? FontWeight.bold : FontWeight.normal,
        ),
      ),
      subtitle: Text(
        song['channel'] ?? '',
        style: const TextStyle(color: Colors.white54),
      ),
      trailing: const Icon(Icons.drag_handle, color: Colors.white30),
      onTap: onTap,
    );
  }

  void _playSong(Map<String, String> song) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) => PlayerScreen(
          title: song['title']!,
          author: song['channel']!,
          url: song['url']!,
          queue: currentQueue + upNextQueue,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black87,
      appBar: AppBar(
        title: const Text("🎶 Song Queue"),
        backgroundColor: Colors.black,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (widget.playlistName != null)
                Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: Text(
                    "📀 Playing from: ${widget.playlistName}",
                    style: const TextStyle(color: Colors.white70, fontSize: 14),
                  ),
                ),
              const Text("🎧 Queue", style: TextStyle(color: Colors.white, fontSize: 18)),
              ReorderableListView(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                onReorder: (oldIndex, newIndex) => _onReorder(currentQueue, oldIndex, newIndex),
                children: List.generate(currentQueue.length, (index) {
                  final song = currentQueue[index];
                  final isCurrent = song['url'] == widget.currentSong['url'];
                  return Container(
                    key: ValueKey(song['url']),
                    child: _buildSongTile(song, isCurrent, () => _playSong(song)),
                  );
                }),
              ),
              const SizedBox(height: 24),
              const Text("🪄 Up Next", style: TextStyle(color: Colors.white, fontSize: 18)),
              ReorderableListView(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                onReorder: (oldIndex, newIndex) => _onReorder(upNextQueue, oldIndex, newIndex),
                children: List.generate(upNextQueue.length, (index) {
                  final song = upNextQueue[index];
                  return Container(
                    key: ValueKey(song['url']),
                    child: _buildSongTile(song, false, () => _playSong(song)),
                  );
                }),
              ),
              const SizedBox(height: 50),
            ],
          ),
        ),
      ),
    );
  }
}
