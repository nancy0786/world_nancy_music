// lib/models/song.dart

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
}
