import 'song_model.dart';
import 'playlist.dart';

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
extension PlaylistModelMapper on PlaylistModel {
  Playlist toPlaylist({required String id, required String createdBy}) {
    return Playlist(
      id: id,
      title: name,
      description: '',
      isPublic: isPublic,
      createdBy: createdBy,
      songs: songs,
    );
  }
}
