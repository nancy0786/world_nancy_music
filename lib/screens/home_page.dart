import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:world_music_nancy/screens/search_screen.dart';
import 'package:world_music_nancy/screens/library_screen.dart';
import 'package:world_music_nancy/screens/profile_screen.dart';
import 'package:world_music_nancy/screens/downloads_screen.dart';

class HomePageWithNav extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageWithNavState extends State<HomePageWithNav> {
  int _selectedIndex = 0;

  final List<Widget> _screens = [
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
    return Scaffold(
      body: _screens[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        selectedItemColor: Colors.pinkAccent,
        unselectedItemColor: Colors.grey,
        backgroundColor: Colors.black,
        items: const [
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
    );
  }
}
