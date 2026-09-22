import 'package:flutter/material.dart';
import '../theme.dart';
import 'dashboard_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});
  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  late Animation<double> _fade, _scale;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
        duration: const Duration(milliseconds: 1600), vsync: this);
    _fade = CurvedAnimation(parent: _ctrl, curve: Curves.easeIn);
    _scale = Tween<double>(begin: 0.75, end: 1.0).animate(
        CurvedAnimation(parent: _ctrl, curve: Curves.easeOutBack));
    _ctrl.forward();
    Future.delayed(const Duration(seconds: 3), () {
      if (!mounted) return;
      Navigator.of(context).pushReplacement(PageRouteBuilder(
        pageBuilder: (_, __, ___) => const DashboardScreen(),
        transitionsBuilder: (_, anim, __, child) =>
            FadeTransition(opacity: anim, child: child),
        transitionDuration: const Duration(milliseconds: 500),
      ));
    });
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xFFF5F0E8), // beige top
              Color(0xFFEDE5D4), // slightly deeper beige
              Color(0xFFE8F0EE), // hint of teal at bottom
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Center(
          child: FadeTransition(
            opacity: _fade,
            child: ScaleTransition(
              scale: _scale,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Logo with navy glow
                  Container(
                    width: 160,
                    height: 160,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                            color: NavExaTheme.brand.withOpacity(0.25),
                            blurRadius: 40,
                            spreadRadius: 8),
                        BoxShadow(
                            color: NavExaTheme.accentTeal.withOpacity(0.15),
                            blurRadius: 60,
                            spreadRadius: 4),
                      ],
                    ),
                    child: ClipOval(
                      child: Image.asset(
                          'assets/images/navexa_logo.jpeg',
                          fit: BoxFit.cover),
                    ),
                  ),
                  const SizedBox(height: 32),
                  ShaderMask(
                    shaderCallback: (bounds) => const LinearGradient(
                      colors: [NavExaTheme.brand, NavExaTheme.accentTeal],
                    ).createShader(bounds),
                    child: const Text('NavExa',
                        style: TextStyle(
                            fontSize: 44,
                            fontWeight: FontWeight.w900,
                            color: Colors.white,
                            letterSpacing: 3)),
                  ),
                  const SizedBox(height: 8),
                  const Text('NAVIGATION BEYOND LIMITS',
                      style: TextStyle(
                          fontSize: 13,
                          color: NavExaTheme.brand,
                          letterSpacing: 4,
                          fontWeight: FontWeight.w600)),
                  const SizedBox(height: 6),
                  const Text('NAVIC  |  AI  |  ALWAYS ON',
                      style: TextStyle(
                          fontSize: 11,
                          color: NavExaTheme.accentOlive,
                          letterSpacing: 3)),
                  const SizedBox(height: 48),
                  const CircularProgressIndicator(
                      strokeWidth: 2.5, color: NavExaTheme.accentTeal),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
