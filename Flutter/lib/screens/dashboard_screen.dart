import 'package:flutter/material.dart';
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
      backgroundColor: const Color(0xFF060E1E),
      body: _screens[_currentIndex],
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: const Color(0xFF0A1628),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF1A6FFF).withOpacity(0.15),
              blurRadius: 20,
              offset: const Offset(0, -4),
            ),
          ],
        ),
        child: NavigationBar(
          backgroundColor: const Color(0xFF0A1628),
          indicatorColor: const Color(0xFF1A6FFF).withOpacity(0.2),
          selectedIndex: _currentIndex,
          onDestinationSelected: (i) => setState(() => _currentIndex = i),
          labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
          destinations: const [
            NavigationDestination(
              icon: Icon(Icons.dashboard_outlined, color: Color(0xFF64B5F6)),
              selectedIcon: Icon(Icons.dashboard, color: Color(0xFF1A6FFF)),
              label: 'Home',
            ),
            NavigationDestination(
              icon: Icon(Icons.map_outlined, color: Color(0xFF64B5F6)),
              selectedIcon: Icon(Icons.map, color: Color(0xFF1A6FFF)),
              label: 'Map',
            ),
            NavigationDestination(
              icon: Icon(Icons.play_circle_outline, color: Color(0xFF64B5F6)),
              selectedIcon: Icon(Icons.play_circle, color: Color(0xFF1A6FFF)),
              label: 'Simulation',
            ),
            NavigationDestination(
              icon: Icon(Icons.analytics_outlined, color: Color(0xFF64B5F6)),
              selectedIcon: Icon(Icons.analytics, color: Color(0xFF1A6FFF)),
              label: 'Analytics',
            ),
            NavigationDestination(
              icon: Icon(Icons.info_outline, color: Color(0xFF64B5F6)),
              selectedIcon: Icon(Icons.info, color: Color(0xFF1A6FFF)),
              label: 'About',
            ),
          ],
        ),
      ),
    );
  }
}

// ── Home Tab ────────────────────────────────────────────────────────────────
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
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFF1A6FFF).withOpacity(0.4),
                        blurRadius: 12,
                      ),
                    ],
                  ),
                  child: ClipOval(
                    child: Image.asset(
                      'assets/images/navexa_logo.jpeg',
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                const SizedBox(width: 14),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text(
                      'NavExa',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w800,
                        color: Colors.white,
                      ),
                    ),
                    Text(
                      'Navigation Beyond Limits',
                      style: TextStyle(fontSize: 12, color: Color(0xFF64B5F6)),
                    ),
                  ],
                ),
                const Spacer(),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  decoration: BoxDecoration(
                    color: Colors.green.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: Colors.green.withOpacity(0.4)),
                  ),
                  child: const Row(
                    children: [
                      Icon(Icons.circle, size: 8, color: Colors.green),
                      SizedBox(width: 5),
                      Text('LIVE',
                          style:
                              TextStyle(color: Colors.green, fontSize: 11)),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 28),

            // Status cards
            Row(
              children: [
                _StatCard(
                  icon: Icons.satellite_alt,
                  label: 'Satellites',
                  value: '8',
                  color: const Color(0xFF1A6FFF),
                ),
                const SizedBox(width: 12),
                _StatCard(
                  icon: Icons.gps_fixed,
                  label: 'GPS Status',
                  value: 'Active',
                  color: Colors.green,
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                _StatCard(
                  icon: Icons.speed,
                  label: 'Speed',
                  value: '42 km/h',
                  color: const Color(0xFF7C83D6),
                ),
                const SizedBox(width: 12),
                _StatCard(
                  icon: Icons.my_location,
                  label: 'Accuracy',
                  value: '±3m',
                  color: Colors.orange,
                ),
              ],
            ),
            const SizedBox(height: 24),

            // NavIC Banner
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF0D2458), Color(0xFF1A3A7A)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: const Color(0xFF1A6FFF).withOpacity(0.3)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.satellite, color: Color(0xFF64B5F6)),
                      const SizedBox(width: 10),
                      const Text(
                        'NavIC Active',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w700,
                          fontSize: 16,
                        ),
                      ),
                      const Spacer(),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 3),
                        decoration: BoxDecoration(
                          color: const Color(0xFF1A6FFF).withOpacity(0.2),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: const Text('NavIC/GPS',
                            style: TextStyle(
                                color: Color(0xFF64B5F6), fontSize: 11)),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    'AI-Powered Navigation Prototype — uses Indian NavIC satellite system with AI dead reckoning for seamless positioning in tunnels and urban canyons.',
                    style: TextStyle(
                        color: Color(0xFF90CAF9), fontSize: 13, height: 1.5),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Feature cards
            const Text(
              'Core Features',
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 17,
                  fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 14),
            _FeatureCard(
              icon: Icons.route,
              title: 'Live Map Navigation',
              subtitle: 'OpenStreetMap with real-time vehicle tracking',
              color: const Color(0xFF1A6FFF),
            ),
            const SizedBox(height: 10),
            _FeatureCard(
              icon: Icons.play_circle,
              title: 'Tunnel Simulation',
              subtitle: 'AI dead reckoning when GPS is unavailable',
              color: Colors.purple,
            ),
            const SizedBox(height: 10),
            _FeatureCard(
              icon: Icons.analytics,
              title: 'Analytics Dashboard',
              subtitle: 'GPS accuracy, signal loss events & performance',
              color: Colors.teal,
            ),
            const SizedBox(height: 20),
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

  const _StatCard({
    required this.icon,
    required this.label,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: const Color(0xFF0A1628),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: color.withOpacity(0.25)),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: color.withOpacity(0.12),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(icon, color: color, size: 20),
            ),
            const SizedBox(width: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label,
                    style: const TextStyle(
                        color: Color(0xFF64B5F6), fontSize: 11)),
                Text(value,
                    style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                        fontSize: 15)),
              ],
            ),
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

  const _FeatureCard({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF0A1628),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: color.withOpacity(0.2)),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: color.withOpacity(0.12),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: color, size: 24),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title,
                    style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                        fontSize: 14)),
                const SizedBox(height: 3),
                Text(subtitle,
                    style: const TextStyle(
                        color: Color(0xFF64B5F6), fontSize: 12)),
              ],
            ),
          ),
          Icon(Icons.chevron_right, color: color.withOpacity(0.6)),
        ],
      ),
    );
  }
}
