import 'song_model.dart';

class Song {
  final String title;
  final String url;
  final String channel;
  final String thumbnail;
  final int duration;
  bool isFavorite;
  bool isDownloaded;

  Song({
    required this.title,
    required this.url,
    required this.channel,
    required this.thumbnail,
    required this.duration,
    this.isFavorite = false,
    this.isDownloaded = false,
  });

  /// ✅ Convert Map to Song (used in fromMap)
  factory Song.fromMap(Map<String, dynamic> map) {
    return Song(
      title: map['title'] ?? '',
      url: map['url'] ?? '',
      channel: map['channel'] ?? '',
      thumbnail: map['thumbnail'] ?? '',
      duration: int.tryParse(map['duration']?.toString() ?? '0') ?? 0,
      isFavorite: map['isFavorite'] == 'true',
      isDownloaded: map['isDownloaded'] == 'true',
    );
  }

  /// ✅ Convert Song to Map (used in toMap)
  Map<String, String> toMap() {
    return {
      'title': title,
      'url': url,
      'channel': channel,
      'thumbnail': thumbnail,
      'duration': duration.toString(),
      'isFavorite': isFavorite.toString(),
      'isDownloaded': isDownloaded.toString(),
    };
  }

  /// ✅ Convert from SongModel (fixes the PlaylistModel to Playlist conversion)
  factory Song.fromModel(SongModel model) {
    return Song(
      title: model.title,
      url: model.url,
      channel: model.channel,
      thumbnail: model.thumbnail ?? '',
      duration: 0, // or parse if you store duration in SongModel later
    );
  }
}
