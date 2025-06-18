import 'package:flutter/material.dart';
import 'package:world_music_nancy/screens/home_screen.dart';
import 'package:world_music_nancy/screens/player_screen.dart';
import 'package:world_music_nancy/screens/search_screen.dart';
import 'package:world_music_nancy/screens/library_screen.dart';
import 'package:world_music_nancy/screens/playlist_screen.dart';
import 'package:world_music_nancy/screens/favorites_screen.dart';
import 'package:world_music_nancy/screens/downloads_screen.dart';
import 'package:world_music_nancy/screens/history_screen.dart';
import 'package:world_music_nancy/screens/playlist_details_screen.dart';
import 'package:world_music_nancy/screens/login_screen.dart';
import 'package:world_music_nancy/screens/register_screen.dart';
import 'package:world_music_nancy/screens/profile_screen.dart';
import 'package:world_music_nancy/screens/splash_screen.dart';

final Map<String, WidgetBuilder> appRoutes = {
  '/': (context) => const SplashScreen(),
  '/home': (context) => const HomeScreen(),
  '/player': (context) => const PlayerScreen(
        title: 'Now Playing',
        author: 'Unknown',
        url: 'https://youtube.com/watch?v=dQw4w9WgXcQ',
      ),
  '/search': (context) => const SearchScreen(),
  '/library': (context) => const LibraryScreen(),
  '/playlist': (context) => const PlaylistScreen(),
  '/favorites': (context) => const FavoritesScreen(),
  '/downloads': (context) => const DownloadsScreen(),
  '/history': (context) => const HistoryScreen(),
  '/login': (context) => const LoginScreen(),
  '/register': (context) => const RegisterScreen(),
  '/profile': (context) => const ProfileScreen(),

  // ✅ Updated route with all required arguments
  '/playlistDetails': (context) {
    final args = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    return PlaylistDetailsScreen(
      playlistName: args['playlistName'] ?? '',
      imagePath: args['imagePath'] ?? '',
      visibility: args['visibility'] ?? 'private', // Default fallback if null
    );
  },
};
