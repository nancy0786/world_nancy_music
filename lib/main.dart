import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:provider/provider.dart';

import 'package:world_music_nancy/screens/splash_screen.dart';
import 'package:world_music_nancy/screens/profile_screen.dart';
import 'package:world_music_nancy/screens/create_playlist.dart';
import 'package:world_music_nancy/screens/downloads_screen.dart';
import 'package:world_music_nancy/screens/history_screen.dart';
import 'package:world_music_nancy/screens/playlist_screen.dart';
import 'package:world_music_nancy/screens/library_screen.dart';
import 'package:world_music_nancy/screens/search_screen.dart';
import 'package:world_music_nancy/screens/playlist_details_screen.dart';
import 'package:world_music_nancy/screens/home_page_with_nav.dart';
import 'package:world_music_nancy/theme.dart';
import 'package:world_music_nancy/routes.dart';
import 'package:world_music_nancy/providers/preferences_provider.dart';
import 'package:world_music_nancy/screens/favorites_screen.dart';

void main() {
  runApp(const NancyMusicWorldApp());
}

class NancyMusicWorldApp extends StatefulWidget {
  const NancyMusicWorldApp({super.key});

  @override
  State<NancyMusicWorldApp> createState() => _NancyMusicWorldAppState();
}

class _NancyMusicWorldAppState extends State<NancyMusicWorldApp> {
  String _currentTheme = 'neon';

  @override
  void initState() {
    super.initState();
    _loadThemePreference();
  }

  Future<void> _loadThemePreference() async {
    final prefs = await SharedPreferences.getInstance();
    final String? theme = prefs.getString('neonTheme');
    if (theme != null) {
      setState(() {
        _currentTheme = theme;
      });
    }
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

  Route<dynamic>? onGenerateRoute(RouteSettings settings) {
    if (settings.name == '/playlistDetails') {
      final args = settings.arguments as Map<String, dynamic>;
      return MaterialPageRoute(
        builder: (context) => PlaylistDetailsScreen(
          playlistName: args['playlistName'] ?? '',
          imagePath: args['imagePath'] ?? '',
          visibility: args['visibility'] ?? 'private',
        ),
      );
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => PreferencesProvider()..loadPreferences()),
      ],
      child: Builder(builder: (context) {
        return MaterialApp(
          title: 'Nancy Music World',
          debugShowCheckedModeBanner: false,
          theme: getCurrentTheme(),
          initialRoute: '/',
          routes: {
            '/': (context) => const SplashScreen(),
            '/home': (context) => const HomePageWithNav(),
            '/profile': (context) => const ProfileScreen(),
            '/createPlaylist': (context) => const CreatePlaylistScreen(),
            '/downloads': (context) => const DownloadsScreen(),
            '/history': (context) => const HistoryScreen(),
            '/playlist': (context) => const PlaylistScreen(),
            '/library': (context) => const LibraryScreen(),
            '/search': (context) => const SearchScreen(),
            '/createPlaylist': (context) => const CreatePlaylistScreen(),
            '/favorites': (context) => const FavoritesScreen(),
            '/playlist': (context) => const PlaylistScreen(),
            '/profile': (context) => const ProfileScreen(),
          },
          onGenerateRoute: onGenerateRoute,
        );
      }),
    );
  }
}
