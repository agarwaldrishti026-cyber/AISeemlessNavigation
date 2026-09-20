import 'package:flutter/material.dart';
import 'dashboard_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  late Animation<double> _fade, _scale;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(duration: const Duration(milliseconds: 1600), vsync: this);
    _fade  = CurvedAnimation(parent: _ctrl, curve: Curves.easeIn);
    _scale = Tween<double>(begin: 0.75, end: 1.0).animate(
      CurvedAnimation(parent: _ctrl, curve: Curves.easeOutBack));
    _ctrl.forward();
    Future.delayed(const Duration(seconds: 3), () {
      if (!mounted) return;
      Navigator.of(context).pushReplacement(PageRouteBuilder(
        pageBuilder: (_, __, ___) => const DashboardScreen(),
        transitionsBuilder: (_, anim, __, child) => FadeTransition(opacity: anim, child: child),
        transitionDuration: const Duration(milliseconds: 500),
      ));
    });
  }

  @override
  void dispose() { _ctrl.dispose(); super.dispose(); }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // bright gradient background
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFE8F0FF), Color(0xFFF5F9FF), Color(0xFFE0F7FA)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
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
                  // Logo with colourful glow
                  Container(
                    width: 160, height: 160,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(color: const Color(0xFF1A6FFF).withOpacity(0.3), blurRadius: 40, spreadRadius: 8),
                        BoxShadow(color: const Color(0xFF00E5FF).withOpacity(0.2), blurRadius: 60, spreadRadius: 4),
                      ],
                    ),
                    child: ClipOval(child: Image.asset('assets/images/navexa_logo.jpeg', fit: BoxFit.cover)),
                  ),
                  const SizedBox(height: 32),
                  ShaderMask(
                    shaderCallback: (bounds) => const LinearGradient(
                      colors: [Color(0xFF1A6FFF), Color(0xFF00E5FF)],
                    ).createShader(bounds),
                    child: const Text('NavExa',
                      style: TextStyle(fontSize: 44, fontWeight: FontWeight.w900, color: Colors.white, letterSpacing: 3)),
                  ),
                  const SizedBox(height: 8),
                  const Text('NAVIGATION BEYOND LIMITS',
                    style: TextStyle(fontSize: 13, color: Color(0xFF1A6FFF), letterSpacing: 4, fontWeight: FontWeight.w600)),
                  const SizedBox(height: 6),
                  const Text('NAVIC  |  AI  |  ALWAYS ON',
                    style: TextStyle(fontSize: 11, color: Color(0xFF7C4DFF), letterSpacing: 3)),
                  const SizedBox(height: 48),
                  const CircularProgressIndicator(strokeWidth: 2.5, color: Color(0xFF1A6FFF)),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
