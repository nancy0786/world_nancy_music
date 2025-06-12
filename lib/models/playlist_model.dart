import 'song_model.dart';

class PlaylistModel {
  final String name;
  final List<SongModel> songs;

  PlaylistModel({required this.name, required this.songs});
}
