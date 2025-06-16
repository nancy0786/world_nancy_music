import 'package:flutter/material.dart';
import 'package:world_music_nancy/components/base_screen.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:world_music_nancy/components/base_screen.dart';
import 'package:nancy_music_world/screens/search_screen.dart';
import 'package:world_music_nancy/components/base_screen.dart';
import 'package:nancy_music_world/screens/library_screen.dart';
import 'package:world_music_nancy/components/base_screen.dart';
import 'package:nancy_music_world/screens/profile_screen.dart';
import 'package:world_music_nancy/components/base_screen.dart';
import 'package:nancy_music_world/screens/downloads_screen.dart';
import 'package:world_music_nancy/components/base_screen.dart';
import 'package:nancy_music_world/utils/constants.dart';
import 'package:world_music_nancy/components/base_screen.dart';

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
