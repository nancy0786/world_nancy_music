import 'package:flutter/material.dart';
import 'package:world_music_nancy/components/base_screen.dart';
import 'package:provider/provider.dart';
import 'package:world_music_nancy/components/base_screen.dart';
import 'package:world_music_nancy/providers/playlist_provider.dart';
import 'package:world_music_nancy/components/base_screen.dart';
import 'package:world_music_nancy/widgets/playlist_tile.dart'; // <-- ADDED
import 'package:world_music_nancy/components/base_screen.dart';
import 'package:world_music_nancy/models/playlist.dart';
import 'package:world_music_nancy/components/base_screen.dart';
import 'package:world_music_nancy/components/cyberpunk_card.dart';
import 'package:world_music_nancy/components/base_screen.dart';
import 'package:world_music_nancy/components/custom_app_bar.dart';
import 'package:world_music_nancy/components/base_screen.dart';
class PlaylistScreen extends StatelessWidget {
  const PlaylistScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final playlists = context.watch<PlaylistProvider>().playlists;

