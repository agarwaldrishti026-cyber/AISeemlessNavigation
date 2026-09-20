import 'package:flutter/material.dart';
import '../theme.dart';
import 'map_screen.dart';
import 'tunnel_screen.dart';
import 'analytics_screen.dart';
import 'about_screen.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});
  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  int _currentIndex = 0;

  final List<Widget> _screens = const [
    _HomeTab(),
    MapScreen(),
    TunnelScreen(),
    AnalyticsScreen(),
    AboutScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: NavExaTheme.bg,
      body: _screens[_currentIndex],
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [BoxShadow(color: NavExaTheme.brand.withOpacity(0.12), blurRadius: 20, offset: const Offset(0, -4))],
        ),
        child: NavigationBar(
          backgroundColor: Colors.white,
          indicatorColor: NavExaTheme.brand.withOpacity(0.12),
          selectedIndex: _currentIndex,
          onDestinationSelected: (i) => setState(() => _currentIndex = i),
          destinations: const [
            NavigationDestination(icon: Icon(Icons.dashboard_outlined), selectedIcon: Icon(Icons.dashboard, color: Color(0xFF1A6FFF)), label: 'Home'),
            NavigationDestination(icon: Icon(Icons.map_outlined), selectedIcon: Icon(Icons.map, color: Color(0xFF1A6FFF)), label: 'Map'),
            NavigationDestination(icon: Icon(Icons.play_circle_outline), selectedIcon: Icon(Icons.play_circle, color: Color(0xFF1A6FFF)), label: 'Simulation'),
            NavigationDestination(icon: Icon(Icons.analytics_outlined), selectedIcon: Icon(Icons.analytics, color: Color(0xFF1A6FFF)), label: 'Analytics'),
            NavigationDestination(icon: Icon(Icons.info_outline), selectedIcon: Icon(Icons.info, color: Color(0xFF1A6FFF)), label: 'About'),
          ],
        ),
      ),
    );
  }
}

// ── Home Tab ─────────────────────────────────────────────────────────────────
class _HomeTab extends StatelessWidget {
  const _HomeTab();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Row(
              children: [
                Container(
                  width: 48, height: 48,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    boxShadow: [BoxShadow(color: NavExaTheme.brand.withOpacity(0.25), blurRadius: 12)],
                  ),
                  child: ClipOval(child: Image.asset('assets/images/navexa_logo.jpeg', fit: BoxFit.cover)),
                ),
                const SizedBox(width: 14),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ShaderMask(
                      shaderCallback: (b) => const LinearGradient(colors: [Color(0xFF1A6FFF), Color(0xFF00E5FF)]).createShader(b),
                      child: const Text('NavExa', style: TextStyle(fontSize: 22, fontWeight: FontWeight.w900, color: Colors.white)),
                    ),
                    const Text('Navigation Beyond Limits', style: TextStyle(fontSize: 12, color: NavExaTheme.textMid)),
                  ],
                ),
                const Spacer(),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  decoration: BoxDecoration(
                    color: const Color(0xFFE8F5E9),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: NavExaTheme.accentGreen.withOpacity(0.4)),
                  ),
                  child: const Row(children: [
                    Icon(Icons.circle, size: 8, color: Color(0xFF00C853)),
                    SizedBox(width: 5),
                    Text('LIVE', style: TextStyle(color: Color(0xFF00C853), fontSize: 11, fontWeight: FontWeight.bold)),
                  ]),
                ),
              ],
            ),
            const SizedBox(height: 24),

            // Stat cards
            Row(children: [
              _StatCard(icon: Icons.satellite_alt, label: 'Satellites', value: '8', color: NavExaTheme.brand, bg: const Color(0xFFE8F0FF)),
              const SizedBox(width: 12),
              _StatCard(icon: Icons.gps_fixed, label: 'GPS Status', value: 'Active', color: NavExaTheme.accentGreen, bg: const Color(0xFFE8F5E9)),
            ]),
            const SizedBox(height: 12),
            Row(children: [
              _StatCard(icon: Icons.speed, label: 'Speed', value: '42 km/h', color: NavExaTheme.accentPurple, bg: const Color(0xFFEDE7F6)),
              const SizedBox(width: 12),
              _StatCard(icon: Icons.my_location, label: 'Accuracy', value: '±3m', color: NavExaTheme.accentOrange, bg: const Color(0xFFFFF3E0)),
            ]),
            const SizedBox(height: 22),

            // NavIC banner
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF1A6FFF), Color(0xFF7C4DFF)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(18),
                boxShadow: [BoxShadow(color: NavExaTheme.brand.withOpacity(0.3), blurRadius: 16, offset: const Offset(0, 6))],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Row(children: [
                    Icon(Icons.satellite, color: Colors.white),
                    SizedBox(width: 10),
                    Text('NavIC Active', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w800, fontSize: 16)),
                    Spacer(),
                    Chip(
                      label: Text('NavIC/GPS', style: TextStyle(color: Colors.white, fontSize: 10)),
                      backgroundColor: Colors.white24,
                      padding: EdgeInsets.zero,
                      labelPadding: EdgeInsets.symmetric(horizontal: 8),
                    ),
                  ]),
                  const SizedBox(height: 10),
                  const Text(
                    'AI-Powered Navigation Prototype — uses Indian NavIC satellite system with AI dead reckoning for seamless positioning in tunnels and urban canyons.',
                    style: TextStyle(color: Colors.white70, fontSize: 13, height: 1.5),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 22),

            const Text('Core Features', style: TextStyle(color: NavExaTheme.textDark, fontSize: 17, fontWeight: FontWeight.w800)),
            const SizedBox(height: 12),
            _FeatureCard(icon: Icons.route, title: 'Live Map Navigation', subtitle: 'OpenStreetMap with real-time vehicle tracking', color: NavExaTheme.brand),
            const SizedBox(height: 10),
            _FeatureCard(icon: Icons.play_circle, title: 'Tunnel Simulation', subtitle: 'AI dead reckoning when GPS is unavailable', color: NavExaTheme.accentPurple),
            const SizedBox(height: 10),
            _FeatureCard(icon: Icons.analytics, title: 'Analytics Dashboard', subtitle: 'GPS accuracy, signal loss events & performance', color: NavExaTheme.accentCyan.withBlue(200)),
          ],
        ),
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color color;
  final Color bg;

  const _StatCard({required this.icon, required this.label, required this.value, required this.color, required this.bg});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: color.withOpacity(0.2)),
          boxShadow: [BoxShadow(color: color.withOpacity(0.08), blurRadius: 12, offset: const Offset(0, 4))],
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(color: bg, borderRadius: BorderRadius.circular(10)),
              child: Icon(icon, color: color, size: 20),
            ),
            const SizedBox(width: 10),
            Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(label, style: const TextStyle(color: NavExaTheme.textMid, fontSize: 11)),
              Text(value, style: TextStyle(color: color, fontWeight: FontWeight.w800, fontSize: 15)),
            ]),
          ],
        ),
      ),
    );
  }
}

class _FeatureCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final Color color;

  const _FeatureCard({required this.icon, required this.title, required this.subtitle, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: color.withOpacity(0.2)),
        boxShadow: [BoxShadow(color: color.withOpacity(0.07), blurRadius: 10, offset: const Offset(0, 4))],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(color: color.withOpacity(0.1), borderRadius: BorderRadius.circular(12)),
            child: Icon(icon, color: color, size: 24),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(title, style: const TextStyle(color: NavExaTheme.textDark, fontWeight: FontWeight.w700, fontSize: 14)),
              const SizedBox(height: 3),
              Text(subtitle, style: const TextStyle(color: NavExaTheme.textMid, fontSize: 12)),
            ]),
          ),
          Icon(Icons.chevron_right, color: color.withOpacity(0.6)),
        ],
      ),
    );
  }
}
