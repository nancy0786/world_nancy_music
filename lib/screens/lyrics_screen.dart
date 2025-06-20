import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:world_music_nancy/services/lyrics_service.dart';
import 'package:just_audio/just_audio.dart';
import 'dart:async';

class LyricsScreen extends StatefulWidget {
  final String title;
  final String artist;
  final AudioPlayer player;

  const LyricsScreen({
    super.key,
    required this.title,
    required this.artist,
    required this.player,
  });

  @override
  State<LyricsScreen> createState() => _LyricsScreenState();
}

class _LyricsScreenState extends State<LyricsScreen> {
  List<_LyricLine> _lines = [];
  int _currentLine = 0;
  ScrollController _scrollController = ScrollController();
  StreamSubscription<Duration>? _positionSub;

  @override
  void initState() {
    super.initState();
    _loadLyrics();
  }

  @override
  void dispose() {
    _positionSub?.cancel();
    super.dispose();
  }

  Future<void> _loadLyrics() async {
    final raw = await LyricsService.fetchLyrics(widget.artist, widget.title);
    if (raw == null) return;

    final lines = _parseLyrics(raw);
    setState(() => _lines = lines);

    _positionSub = widget.player.positionStream.listen((pos) {
      final ms = pos.inMilliseconds;
      for (int i = 0; i < _lines.length; i++) {
        final start = _lines[i].timestamp;
        final end = (i + 1 < _lines.length) ? _lines[i + 1].timestamp : double.infinity;
        if (ms >= start && ms < end) {
          if (_currentLine != i) {
            setState(() => _currentLine = i);
            _scrollToLine(i);
          }
          break;
        }
      }
    });
  }

  void _scrollToLine(int i) {
    final offset = i * 48.0; // line height
    _scrollController.animateTo(offset, duration: Duration(milliseconds: 400), curve: Curves.easeInOut);
  }

  List<_LyricLine> _parseLyrics(String raw) {
    final lines = raw.trim().split('\n');
    final parsed = <_LyricLine>[];

    final timestampReg = RegExp(r'(\d+):(\d+).(\d+)');
    for (final line in lines) {
      final match = timestampReg.firstMatch(line);
      if (match != null) {
        final min = int.parse(match.group(1)!);
        final sec = int.parse(match.group(2)!);
        final ms = int.parse(match.group(3)!);
        final text = line.replaceFirst(timestampReg, '').trim();
        final timeMs = (min * 60 + sec) * 1000 + ms * 10;
        parsed.add(_LyricLine(text, timeMs.toDouble()));
      } else {
        parsed.add(_LyricLine(line.trim(), 0));
      }
    }

    return parsed;
  }

  void _seekToLine(int i) {
    if (i < _lines.length) {
      final millis = _lines[i].timestamp.toInt();
      widget.player.seek(Duration(milliseconds: millis));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: Text("🎤 Lyrics", style: TextStyle(fontFamily: 'DancingScript')),
        centerTitle: true,
        elevation: 0,
      ),
      body: _lines.isEmpty
          ? const Center(child: CircularProgressIndicator(color: Colors.cyanAccent))
          : ListView.builder(
              controller: _scrollController,
              itemCount: _lines.length,
              itemBuilder: (_, i) {
                final isActive = i == _currentLine;
                return GestureDetector(
                  onTap: () => _seekToLine(i),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 6.0, horizontal: 20),
                    child: Center(
                      child: Text(
                        _lines[i].text,
                        textAlign: TextAlign.center,
                        style: GoogleFonts.lato(
                          fontSize: isActive ? 20 : 16,
                          fontWeight: isActive ? FontWeight.bold : FontWeight.w400,
                          color: isActive ? Colors.cyanAccent : Colors.white70,
                          shadows: isActive
                              ? [Shadow(color: Colors.pinkAccent, blurRadius: 10)]
                              : [],
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
    );
  }
}

class _LyricLine {
  final String text;
  final double timestamp; // in milliseconds

  _LyricLine(this.text, this.timestamp);
}
