class SongModel {
  final String title;
  final String url;
  final String channel;
  final String id;
  final String? artist;         // Optional, may be null
  final String? thumbnail;      // Optional, for recently_played_tile
  final String? thumbnailUrl;   // Optional, for history_tile

  SongModel({
    required this.title,
    required this.url,
    required this.channel,
    required this.id,
    this.artist,
    this.thumbnail,
    this.thumbnailUrl,
  });
}
