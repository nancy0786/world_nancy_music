// lib/data/playlist_data.dart

import 'package:world_music_nancy/models/playlist.dart';
import 'package:world_music_nancy/models/song.dart';

final List<Playlist> samplePlaylists = [
  Playlist(
    id: '1',
    title: 'Neon Vibes',
    description: 'Futuristic synth and electronic tracks',
    isPublic: true,
    createdBy: 'admin',
    songs: [
      Song(
        id: 'song1',
        title: 'Cyberdream',
        artist: 'DJ Neon',
        url: 'https://example.com/song1.mp3',
        thumbnailUrl: 'https://example.com/thumb1.jpg',
      ),
      Song(
        id: 'song2',
        title: 'Tech Pulse',
        artist: 'RoboBeat',
        url: 'https://example.com/song2.mp3',
        thumbnailUrl: 'https://example.com/thumb2.jpg',
      ),
    ],
  ),
  Playlist(
    id: '2',
    title: 'Chill Synthwave',
    description: 'Relax and vibe with smooth synthwave sounds',
    isPublic: false,
    createdBy: 'user123',
    songs: [],
  ),
];
