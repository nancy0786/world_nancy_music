# lib/routes.dart

import 'package:flutter/material.dart';
import 'package:nancy_music_world/screens/home_screen.dart';
import 'package:nancy_music_world/screens/player_screen.dart';
import 'package:nancy_music_world/screens/search_screen.dart';
import 'package:nancy_music_world/screens/library_screen.dart';
import 'package:nancy_music_world/screens/playlist_screen.dart';
import 'package:nancy_music_world/screens/favorites_screen.dart';
import 'package:nancy_music_world/screens/downloads_screen.dart';
import 'package:nancy_music_world/screens/history_screen.dart';
import 'package:nancy_music_world/screens/playlist_details_screen.dart';
import 'package:nancy_music_world/screens/login_screen.dart';
import 'package:nancy_music_world/screens/register_screen.dart';
import 'package:nancy_music_world/screens/profile_screen.dart';
import 'package:nancy_music_world/screens/splash_screen.dart';

final Map<String, WidgetBuilder> appRoutes = {
  '/': (context) => const SplashScreen(),
  '/home': (context) => const HomeScreen(),
  '/player': (context) => const PlayerScreen(),
  '/search': (context) => const SearchScreen(),
  '/library': (context) => const LibraryScreen(),
  '/playlist': (context) => const PlaylistScreen(),
  '/favorites': (context) => const FavoritesScreen(),
  '/downloads': (context) => const DownloadsScreen(),
  '/history': (context) => const HistoryScreen(),
  '/playlistDetails': (context) => const PlaylistDetailsScreen(),
  '/login': (context) => const LoginScreen(),
  '/register': (context) => const RegisterScreen(),
  '/profile': (context) => const ProfileScreen(),
};
