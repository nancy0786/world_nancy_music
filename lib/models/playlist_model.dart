import 'song_model.dart';
import 'playlist.dart';
import 'song.dart'; // ✅ Required to access Song.fromModel

class PlaylistModel {
  final String name;
  final List<SongModel> songs;
  bool isPublic;

  PlaylistModel({
    required this.name,
    required this.songs,
    this.isPublic = false,
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
      songs: songs.map((s) => Song.fromModel(s)).toList(), // ✅ Key Fix
    );
  }
}
