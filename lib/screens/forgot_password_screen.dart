import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:world_music_nancy/components/base_screen.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _otpController = TextEditingController();
  final TextEditingController _newPass = TextEditingController();

  bool _otpSent = false;
  String? _error;
  String _generatedOtp = '123456'; // fake OTP

  Future<void> _sendOtp() async {
    final prefs = await SharedPreferences.getInstance();
    final email = _emailController.text.trim();
    final storedEmail = prefs.getString('user_email');

    if (email != storedEmail) {
      setState(() => _error = "❌ Email not found. Please register.");
      return;
    }

    setState(() {
      _otpSent = true;
      _error = null;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("📩 OTP sent: 123456")),
    );
  }

  Future<void> _resetPassword() async {
    if (_otpController.text.trim() != _generatedOtp) {
      setState(() => _error = "❌ Invalid OTP");
      return;
    }

    if (_newPass.text.length < 8) {
      setState(() => _error = "🔒 Password must be at least 8 characters");
      return;
    }

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('user_password', _newPass.text.trim());

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("✅ Password reset successful!")));
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return BaseScreen(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(title: const Text("🔐 Forgot Password"), backgroundColor: Colors.black),
        body: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              TextField(
                controller: _emailController,
                decoration: const InputDecoration(
                  labelText: "Registered Email",
                  labelStyle: TextStyle(color: Colors.white70),
                  filled: true,
                  fillColor: Colors.black45,
                ),
                style: const TextStyle(color: Colors.white),
              ),
              const SizedBox(height: 16),
              if (_otpSent)
                Column(
                  children: [
                    TextField(
                      controller: _otpController,
                      decoration: const InputDecoration(
                        labelText: "Enter OTP",
                        labelStyle: TextStyle(color: Colors.white70),
                        filled: true,
                        fillColor: Colors.black45,
                      ),
                      style: const TextStyle(color: Colors.white),
                    ),
                    const SizedBox(height: 10),
                    TextField(
                      controller: _newPass,
                      obscureText: true,
                      decoration: const InputDecoration(
                        labelText: "New Password",
                        labelStyle: TextStyle(color: Colors.white70),
                        filled: true,
                        fillColor: Colors.black45,
                      ),
                      style: const TextStyle(color: Colors.white),
                    ),
                    const SizedBox(height: 10),
                  ],
                ),
              ElevatedButton(
                onPressed: _otpSent ? _resetPassword : _sendOtp,
                child: Text(_otpSent ? 'Reset Password' : 'Send OTP'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.pinkAccent,
                ),
              ),
              if (_error != null) ...[
                const SizedBox(height: 12),
                Text(_error!, style: const TextStyle(color: Colors.redAccent)),
              ]
            ],
          ),
        ),
      ),
    );
  }
}
