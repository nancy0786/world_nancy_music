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
    return BaseScreen(child: Scaffold(backgroundColor: Colors.transparent,
      body: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset(
            'assets/backgrounds/cyber/cyber1.jpg',
            fit: BoxFit.cover,
          ),
          Container(
            color: Colors.black.withOpacity(0.5),
          ),
          Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Lottie.asset('assets/lottie/loading.json', height: 150),
                const SizedBox(height: 30),
                const Text(
                  "Nancy Music World",
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    letterSpacing: 2,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
);
}
