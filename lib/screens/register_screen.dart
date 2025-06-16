import 'package:flutter/material.dart';
import 'package:world_music_nancy/components/base_screen.dart';

class RegisterScreen extends StatelessWidget {
  const RegisterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BaseScreen(
      child: const Scaffold(
        backgroundColor: Colors.transparent,
        body: Center(
          child: Text(
            'Register Page',
            style: TextStyle(color: Colors.white),
          ),
        ),
      ),
    );
  }
}
