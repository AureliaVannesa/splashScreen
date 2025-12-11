import 'package:flutter/material.dart';
import 'package:wisata_ku/ui/splash_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'WisataKu',
      debugShowCheckedModeBanner: false,
      home: SplashScreen(),
    );
  }
}
