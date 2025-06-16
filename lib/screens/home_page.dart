import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nancy_music_world/screens/search_screen.dart';
import 'package:nancy_music_world/screens/library_screen.dart';
import 'package:nancy_music_world/screens/profile_screen.dart';
import 'package:nancy_music_world/screens/downloads_screen.dart';
import 'package:nancy_music_world/utils/constants.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
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
      backgroundColor: AppColors.darkBackground,
      body: _screens[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        backgroundColor: Colors.black,
        selectedItemColor: AppColors.neonPink,
        unselectedItemColor: Colors.grey,
        selectedLabelStyle: GoogleFonts.orbitron(fontWeight: FontWeight.bold),
        unselectedLabelStyle: GoogleFonts.orbitron(),
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
