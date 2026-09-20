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
          indicatorColor: NavExaTheme.brand.withOpacity(0.15),
          labelTextStyle: WidgetStateProperty.all(
            const TextStyle(fontSize: 11, fontWeight: FontWeight.w600),
          ),
          elevation: 8,
          shadowColor: NavExaTheme.brand.withOpacity(0.1),
        ),
        cardTheme: CardTheme(
          color: NavExaTheme.cardBg,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
            side: BorderSide(color: NavExaTheme.cardBorder),
          ),
        ),
        appBarTheme: AppBarTheme(
          backgroundColor: Colors.white,
          foregroundColor: NavExaTheme.textDark,
          elevation: 0,
          shadowColor: NavExaTheme.brand.withOpacity(0.1),
          surfaceTintColor: Colors.transparent,
        ),
      ),
      home: const SplashScreen(),
    );
  }
}
