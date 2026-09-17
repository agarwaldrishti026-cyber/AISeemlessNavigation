import 'package:flutter/material.dart';
import 'screens/splash_screen.dart';

void main() {
  runApp(const NavExaApp());
}

class NavExaApp extends StatelessWidget {
  const NavExaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'NavExa',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF1A6FFF),
          brightness: Brightness.dark,
        ),
        useMaterial3: true,
        scaffoldBackgroundColor: const Color(0xFF060E1E),
      ),
      home: const SplashScreen(),
    );
  }
}
