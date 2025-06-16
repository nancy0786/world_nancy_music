class SongModel {
  final String title;
  final String url;
  final String channel;
  final String id;
  final String? artist;         // Optional, may be null
  final String? thumbnail;      // Used in RecentlyPlayedTile
  final String? thumbnailUrl;   // Used in HistoryTile

  const SongModel({
    required this.title,
    required this.url,
    required this.channel,
    required this.id,
    this.artist,
    this.thumbnail,
    this.thumbnailUrl,
  });

  factory SongModel.fromMap(Map<String, dynamic> map) {
    return SongModel(
      title: map['title'] ?? '',
      url: map['url'] ?? '',
      channel: map['channel'] ?? '',
      id: map['id'] ?? '',
      artist: map['artist'],
      thumbnail: map['thumbnail'],
      thumbnailUrl: map['thumbnailUrl'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'url': url,
      'channel': channel,
      'id': id,
      'artist': artist,
      'thumbnail': thumbnail,
      'thumbnailUrl': thumbnailUrl,
    };
  }
}
