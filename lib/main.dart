import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:world_music_nancy/screens/splash_screen.dart';
import 'package:world_music_nancy/theme.dart'; // Custom theme file
import 'package:world_music_nancy/screens/profile_screen.dart';
import 'package:world_music_nancy/screens/create_playlist.dart';
import 'package:world_music_nancy/screens/downloads_screen.dart';
import 'package:world_music_nancy/screens/history_screen.dart';
import 'package:world_music_nancy/home.dart';
import 'package:world_music_nancy/screens/playlist_screen.dart';
import 'package:world_music_nancy/screens/library_screen.dart';
import 'package:world_music_nancy/screens/search_screen.dart';
import 'package:world_music_nancy/routes.dart';
import 'package:world_music_nancylib/screens/home_page_with_nav.dart';
void main() {
  runApp(const NancyMusicWorldApp());
}

class NancyMusicWorldApp extends StatefulWidget {
  const NancyMusicWorldApp({super.key});

  @override
  State<NancyMusicWorldApp> createState() => _NancyMusicWorldAppState();
}

class _NancyMusicWorldAppState extends State<NancyMusicWorldApp> {
  String _currentTheme = 'neon'; // Default theme

  @override
  void initState() {
    super.initState();
    _loadThemePreference();
  }

  Future<void> _loadThemePreference() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? theme = prefs.getString('neonTheme');
    if (theme != null) {
      setState(() {
        _currentTheme = theme;
      });
    }
  }

  Future<void> _changeTheme(String themeName) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('neonTheme', themeName);
    setState(() {
      _currentTheme = themeName;
    });
  }

  void _toggleTheme() {
    // Optional logic to cycle through themes can be added here
  }

  ThemeData getCurrentTheme() {
    switch (_currentTheme.toLowerCase()) {
      case 'light':
        return lightTheme;
      case 'dark':
        return darkTheme;
      case 'neon':
      default:
        return neonTheme;
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Nancy Music World',
      debugShowCheckedModeBanner: false,
      theme: getCurrentTheme(), // Fixed this line
      initialRoute: '/',
      routes: {
        '/': (context) => const SplashScreen(),
        '/home': (context) => const HomePageWithNav(), // ✅ The one with bottom navigation
        '/profile': (context) => const ProfileScreen(),
        '/createPlaylist': (context) => const CreatePlaylistScreen(),
        '/downloads': (context) => const DownloadsScreen(),
        '/history': (context) => const HistoryScreen(),
        '/playlist': (context) => const PlaylistScreen(),
        '/library': (context) => const LibraryScreen(),
        '/search': (context) => const SearchScreen(),
      },
    );
  }
}
