import 'package:flutter/material.dart';
import 'package:world_music_nancy/models/playlist.dart';
import 'package:world_music_nancy/models/song_model.dart';
import 'package:world_music_nancy/models/playlist_model.dart';

class PlaylistProvider with ChangeNotifier {
  final List<PlaylistModel> _playlists = [];

  List<PlaylistModel> get playlists => _playlists;

  void createPlaylist(String name, {bool isPublic = false}) {
    final playlist = PlaylistModel(name: name, songs: [], isPublic: isPublic);
    _playlists.add(playlist);
    notifyListeners();
  }

  void deletePlaylist(String name) {
    _playlists.removeWhere((playlist) => playlist.name == name);
    notifyListeners();
  }

  void addSongToPlaylist(String playlistName, SongModel song) {
    final playlist = _playlists.firstWhere((p) => p.name == playlistName);
    playlist.songs.add(song);
    notifyListeners();
  }

  void removeSongFromPlaylist(String playlistName, SongModel song) {
    final playlist = _playlists.firstWhere((p) => p.name == playlistName);
    playlist.songs.removeWhere((s) => s.url == song.url);
    notifyListeners();
  }

  void togglePrivacy(String playlistName) {
    final playlist = _playlists.firstWhere((p) => p.name == playlistName);
    playlist.isPublic = !playlist.isPublic;
    notifyListeners();
  }

  PlaylistModel? getPlaylistByName(String name) {
    return _playlists.firstWhere((p) => p.name == name, orElse: () => PlaylistModel(name: name, songs: []));
  }
}
