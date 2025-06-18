import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:world_music_nancy/components/base_screen.dart';
import 'package:world_music_nancy/screens/login_screen.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _dobController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _pass1 = TextEditingController();
  final TextEditingController _pass2 = TextEditingController();
  final TextEditingController _otp = TextEditingController();

  String? _error;
  String _generatedOtp = '';
  bool _otpSent = false;

  final RegExp _dobRegex = RegExp(r'^\d{2}/\d{2}/\d{4}$');

  Future<void> _sendOtp() async {
    final email = _emailController.text.trim();
    if (!email.contains('@')) {
      setState(() => _error = "Enter a valid email address.");
      return;
    }

    final prefs = await SharedPreferences.getInstance();
    final existing = prefs.getString('user_email');
    if (existing == email) {
      setState(() => _error = "Account already exists. Please login.");
      return;
    }

    setState(() {
      _generatedOtp = '123456'; // Mocked OTP
      _otpSent = true;
      _error = null;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("OTP sent: 123456")),
    );
  }

  Future<void> _register() async {
    final name = _nameController.text.trim();
    final dob = _dobController.text.trim();
    final email = _emailController.text.trim();
    final password1 = _pass1.text;
    final password2 = _pass2.text;
    final enteredOtp = _otp.text.trim();

    if (name.length < 3) {
      setState(() => _error = "Name must be at least 3 characters.");
      return;
    }

    if (!_dobRegex.hasMatch(dob)) {
      setState(() => _error = "DOB must be in DD/MM/YYYY format.");
      return;
    }

    if (!email.contains('@')) {
      setState(() => _error = "Invalid email address.");
      return;
    }

    if (password1.length < 8) {
      setState(() => _error = "Password must be at least 8 characters.");
      return;
    }

    if (password1 != password2) {
      setState(() => _error = "Passwords do not match.");
      return;
    }

    if (!_otpSent || enteredOtp != _generatedOtp) {
      setState(() => _error = "Invalid or missing OTP.");
      return;
    }

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('user_name', name);
    await prefs.setString('user_dob', dob);
    await prefs.setString('user_email', email);
    await prefs.setString('user_password', password1);

    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("🎉 Registration successful! Please login.")),
    );
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const LoginScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BaseScreen(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                '🚀 Register Now',
                style: TextStyle(
                  fontSize: 24,
                  color: Colors.cyanAccent,
                  fontWeight: FontWeight.bold,
                  shadows: [Shadow(blurRadius: 10, color: Colors.pinkAccent)],
                ),
              ),
              const SizedBox(height: 30),
              _buildInput(_nameController, "Full Name"),
              const SizedBox(height: 12),
              _buildInput(_dobController, "Date of Birth (DD/MM/YYYY)"),
              const SizedBox(height: 12),
              _buildInput(_emailController, "Email"),
              const SizedBox(height: 12),
              _buildInput(_pass1, "Create Password", isObscure: true),
              const SizedBox(height: 12),
              _buildInput(_pass2, "Confirm Password", isObscure: true),
              const SizedBox(height: 12),
              if (_otpSent)
                _buildInput(_otp, "Enter OTP"),
              const SizedBox(height: 10),
              ElevatedButton.icon(
                onPressed: _otpSent ? _register : _sendOtp,
                icon: Icon(_otpSent ? Icons.check : Icons.email),
                label: Text(_otpSent ? "Register" : "Send OTP"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.pinkAccent,
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
                ),
              ),
              if (_error != null) ...[
                const SizedBox(height: 10),
                Text(_error!, style: const TextStyle(color: Colors.redAccent)),
              ],
              const SizedBox(height: 20),
              GestureDetector(
                onTap: () => Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (_) => const LoginScreen()),
                ),
                child: const Text(
                  "Already have an account? Login",
                  style: TextStyle(color: Colors.white70),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInput(TextEditingController controller, String label, {bool isObscure = false}) {
    return TextField(
      controller: controller,
      obscureText: isObscure,
      style: const TextStyle(color: Colors.white),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(color: Colors.white70),
        filled: true,
        fillColor: Colors.black45,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }
}
