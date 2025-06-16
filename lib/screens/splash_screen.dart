import 'package:flutter/material.dart';
import 'package:world_music_nancy/components/base_screen.dart';
import 'dart:async';
import 'package:world_music_nancy/components/base_screen.dart';
import 'package:lottie/lottie.dart';
import 'package:world_music_nancy/components/base_screen.dart';
import 'package:world_music_nancy/home.dart'; // Correct import
import 'package:world_music_nancy/components/base_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Timer(const Duration(seconds: 4), () {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => const HomePage()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
