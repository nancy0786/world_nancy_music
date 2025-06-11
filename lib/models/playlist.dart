import 'song.dart';

class Playlist {
  final String id;
  final String title;
  final String description;
  final bool isPublic;
  final String createdBy;
  final List<Song> songs;

  const Playlist({
    required this.id,
    required this.title,
    required this.description,
    required this.isPublic,
    required this.createdBy,
    required this.songs,
  });

  factory Playlist.fromMap(Map<String, dynamic> map) {
    return Playlist(
      id: map['id'] ?? '',
      title: map['title'] ?? '',
      description: map['description'] ?? '',
      isPublic: map['isPublic'] == true || map['isPublic'] == 'true',
      createdBy: map['createdBy'] ?? '',
      songs: (map['songs'] as List<dynamic>?)
              ?.map((songMap) => Song.fromMap(songMap as Map<String, dynamic>))
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'isPublic': isPublic,
      'createdBy': createdBy,
      'songs': songs.map((song) => song.toMap()).toList(),
    };
  }
}
