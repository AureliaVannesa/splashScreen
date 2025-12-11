import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart'; // Import package baru
import 'package:lottie/lottie.dart';
import 'wisata_page.dart';
import 'login_page.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _checkAuthAndNavigate();
  }

  void _checkAuthAndNavigate() async {
    const minimumSplashDuration = Duration(seconds: 8);
    final startTime = DateTime.now();

    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('auth_token');

    final endTime = DateTime.now();
    final durationPassed = endTime.difference(startTime);
    if (durationPassed < minimumSplashDuration) {
      await Future.delayed(minimumSplashDuration - durationPassed);
    }

    if (mounted) {
      if (token != null) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const WisataPage()),
        );
      } else {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const LoginPage()),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFBA68C8),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Lottie.asset(
              'assets/lottie/mountain.json',
              width: 500,
              height: 500,
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
