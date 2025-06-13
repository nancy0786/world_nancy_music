import 'song_model.dart';

class PlaylistModel {
  final String name;
  final List<SongModel> songs;
  bool isPublic; // Added to fix isPublic related errors

  PlaylistModel({
    required this.name,
    required this.songs,
    this.isPublic = false, // Default to false
  });
}
