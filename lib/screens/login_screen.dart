import 'dart:math';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:world_music_nancy/components/base_screen.dart';
import 'package:world_music_nancy/screens/home_page_with_nav.dart';
import 'package:world_music_nancy/screens/register_screen.dart';
import 'package:world_music_nancy/screens/forgot_password_screen.dart';
import 'package:world_music_nancy/services/email_service.dart'; // 🔁 New

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _loading = false;

  Future<void> _login() async {
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();

    if (email.isEmpty || password.isEmpty || !email.contains('@')) {
      _showMessage("⚠️ Enter a valid email and password");
      return;
    }

    final prefs = await SharedPreferences.getInstance();
    final storedEmail = prefs.getString('user_email');
    final storedPassword = prefs.getString('user_password');

    if (storedEmail == null || storedPassword == null) {
      _showMessage("❌ Account not found. Please sign up.");
      return;
    }

    if (email != storedEmail) {
      _showMessage("❌ No account with this email.");
      return;
    }

    if (password != storedPassword) {
      _showMessage("❌ Incorrect password.");
      return;
    }

    // ✅ Login success - save session
    await prefs.setString('active_user', email);

    // 📨 Send login code via email
    final code = _generateCode();
    final success = await EmailService.sendLoginCode(email, code);
    if (success) {
      _showMessage("📨 Login code sent to your email");
    }

    if (!mounted) return;
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const HomePageWithNav()),
    );
  }

  String _generateCode() {
    final r = Random();
    return (100000 + r.nextInt(900000)).toString();
  }

  void _showMessage(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
  }

  @override
  Widget build(BuildContext context) {
    return BaseScreen(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Padding(
          padding: const EdgeInsets.all(24),
          child: Center(
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    '🎵 Nancy Music World',
                    style: TextStyle(
                      fontSize: 24,
                      color: Colors.cyanAccent,
                      fontWeight: FontWeight.bold,
                      shadows: [Shadow(color: Colors.pinkAccent, blurRadius: 10)],
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 30),
                  TextField(
                    controller: _emailController,
                    style: const TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      labelText: "Email",
                      labelStyle: const TextStyle(color: Colors.white70),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                      filled: true,
                      fillColor: Colors.black54,
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: _passwordController,
                    obscureText: true,
                    style: const TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      labelText: "Password",
                      labelStyle: const TextStyle(color: Colors.white70),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                      filled: true,
                      fillColor: Colors.black54,
                    ),
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton(
                    onPressed: _loading ? null : _login,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.pinkAccent,
                      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 14),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    ),
                    child: Text(_loading ? "Logging in..." : "Login", style: const TextStyle(fontSize: 16)),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.push(context,
                        MaterialPageRoute(builder: (_) => const ForgotPasswordScreen()));
                    },
                    child: const Text("Forgot Password?", style: TextStyle(color: Colors.cyanAccent)),
                  ),
                  const SizedBox(height: 12),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const RegisterScreen()),
                      );
                    },
                    child: const Text(
                      "Don't have an account? Sign Up",
                      style: TextStyle(color: Colors.white60),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
