import 'package:flutter/material.dart';
import 'package:world_music_nancy/widgets/background_manager.dart';
import 'package:world_music_nancy/screens/home_screen.dart'; // ✅ Home screen added
import 'package:world_music_nancy/screens/search_screen.dart';
import 'package:world_music_nancy/screens/library_screen.dart';
import 'package:world_music_nancy/screens/profile_screen.dart';
import 'package:world_music_nancy/screens/downloads_screen.dart';

class HomePageWithNav extends StatefulWidget {
  const HomePageWithNav({super.key});

  @override
  State<HomePageWithNav> createState() => _HomePageWithNavState();
}

class _HomePageWithNavState extends State<HomePageWithNav> {
  int _selectedIndex = 0;

  final List<Widget> _screens = [
    const HomeScreen(),     // 🏠 Home is now first
    const SearchScreen(),
    const LibraryScreen(),
    const DownloadsScreen(),
    const ProfileScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        const BackgroundManager(),
        Scaffold(
          backgroundColor: Colors.transparent,
          body: _screens[_selectedIndex],
          bottomNavigationBar: BottomNavigationBar(
            currentIndex: _selectedIndex,
            onTap: _onItemTapped,
            selectedItemColor: Colors.pinkAccent,
            unselectedItemColor: Colors.grey,
            backgroundColor: Colors.black,
            items: const [
              BottomNavigationBarItem(
                icon: Icon(Icons.home),
                label: 'Home',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.search),
                label: 'Search',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.library_music),
                label: 'Library',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.download),
                label: 'Downloads',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.person),
                label: 'Profile',
              ),
            ],
          ),
        ),
      ],
    );
  }
}
