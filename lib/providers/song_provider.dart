import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:nancy_music_world/models/song_model.dart';

class SongProvider with ChangeNotifier {
  final AudioPlayer _audioPlayer = AudioPlayer();
  SongModel? _currentSong;
  bool _isPlaying = false;

  SongModel? get currentSong => _currentSong;
  bool get isPlaying => _isPlaying;
  AudioPlayer get audioPlayer => _audioPlayer;

  Future<void> setSong(SongModel song) async {
    try {
      _currentSong = song;
      await _audioPlayer.setUrl(song.url);
      play();
      notifyListeners();
    } catch (e) {
      debugPrint("Error setting song: $e");
    }
  }

  void play() {
    _audioPlayer.play();
    _isPlaying = true;
    notifyListeners();
  }

  void pause() {
    _audioPlayer.pause();
    _isPlaying = false;
    notifyListeners();
  }

  void stop() {
    _audioPlayer.stop();
    _isPlaying = false;
    notifyListeners();
  }

  void togglePlayPause() {
    if (_isPlaying) {
      pause();
    } else {
      play();
    }
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }
}
