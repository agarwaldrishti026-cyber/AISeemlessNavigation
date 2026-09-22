import 'package:flutter/material.dart';
import 'screens/splash_screen.dart';
import 'theme.dart';

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
          seedColor: NavExaTheme.brand,
          brightness: Brightness.light,
          surface: NavExaTheme.bg,
          primary: NavExaTheme.brand,
        ),
        useMaterial3: true,
        scaffoldBackgroundColor: NavExaTheme.bg,
        fontFamily: 'Arial',
        navigationBarTheme: NavigationBarThemeData(
          backgroundColor: NavExaTheme.navBar,
          indicatorColor: NavExaTheme.brand.withOpacity(0.12),
          labelTextStyle: WidgetStateProperty.all(
            const TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: NavExaTheme.textMid),
          ),
          elevation: 4,
          shadowColor: NavExaTheme.brand.withOpacity(0.08),
        ),
        cardTheme: CardThemeData(
          color: NavExaTheme.cardBg,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
            side: const BorderSide(color: NavExaTheme.cardBorder),
          ),
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: NavExaTheme.cardBg,
          foregroundColor: NavExaTheme.textDark,
          elevation: 0,
          surfaceTintColor: Colors.transparent,
        ),
      ),
      home: const SplashScreen(),
    );
  }
}
