import 'package:flutter/material.dart';
import '../theme.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: NavExaTheme.bg,
      appBar: AppBar(
        backgroundColor: NavExaTheme.cardBg,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Container(color: NavExaTheme.cardBorder, height: 1),
        ),
        title: Row(children: [
          Container(width: 32, height: 32,
              decoration: const BoxDecoration(shape: BoxShape.circle),
              child: ClipOval(child: Image.asset(
                  'assets/images/navexa_logo.jpeg', fit: BoxFit.cover))),
          const SizedBox(width: 10),
          const Text('About NavExa',
              style: TextStyle(
                  color: NavExaTheme.textDark, fontWeight: FontWeight.w700)),
        ]),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(children: [
            // Hero banner — navy → teal gradient
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(28),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [
                    NavExaTheme.brand,
                    Color(0xFF1E5F74),
                    NavExaTheme.accentTeal,
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(24),
                boxShadow: [BoxShadow(
                    color: NavExaTheme.brand.withOpacity(0.3),
                    blurRadius: 20,
                    offset: const Offset(0, 8))],
              ),
              child: Column(children: [
                Container(
                  width: 100, height: 100,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white, width: 3),
                    boxShadow: [BoxShadow(
                        color: Colors.black.withOpacity(0.2), blurRadius: 16)],
                  ),
                  child: ClipOval(child: Image.asset(
                      'assets/images/navexa_logo.jpeg', fit: BoxFit.cover)),
                ),
                const SizedBox(height: 16),
                const Text('NavExa', style: TextStyle(
                    fontSize: 32, fontWeight: FontWeight.w900,
                    color: Colors.white, letterSpacing: 3)),
                const SizedBox(height: 5),
                const Text('NAVIGATION BEYOND LIMITS', style: TextStyle(
                    color: Colors.white70, fontSize: 12, letterSpacing: 4)),
                const SizedBox(height: 4),
                const Text('NAVIC  |  AI  |  ALWAYS ON', style: TextStyle(
                    color: Colors.white60, fontSize: 11, letterSpacing: 3)),
                const SizedBox(height: 16),
                Row(mainAxisAlignment: MainAxisAlignment.center, children: const [
                  _HeroBadge(label: 'v1.0.0'),
                  SizedBox(width: 10),
                  _HeroBadge(label: 'Flutter'),
                  SizedBox(width: 10),
                  _HeroBadge(label: 'NavIC'),
                ]),
              ]),
            ),
            const SizedBox(height: 20),

            _infoCard(
              title: 'About Project',
              icon: Icons.info_outline,
              color: NavExaTheme.brand,
              content:
                  'NavExa is an AI-powered navigation prototype leveraging India\'s NavIC satellite system with intelligent dead reckoning to provide continuous, uninterrupted positioning — even in tunnels, underground parking, and dense urban environments.',
            ),
            const SizedBox(height: 14),

            const Align(
              alignment: Alignment.centerLeft,
              child: Text('Key Technologies',
                  style: TextStyle(
                      color: NavExaTheme.textDark,
                      fontWeight: FontWeight.w800,
                      fontSize: 15)),
            ),
            const SizedBox(height: 12),
            ..._techItems().map((item) => Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: NavExaTheme.cardBg,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(
                      color: (item['color'] as Color).withOpacity(0.2)),
                  boxShadow: [BoxShadow(
                      color: (item['color'] as Color).withOpacity(0.06),
                      blurRadius: 8, offset: const Offset(0, 3))],
                ),
                child: Row(children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: item['bg'] as Color,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(item['icon'] as IconData,
                        color: item['color'] as Color, size: 22),
                  ),
                  const SizedBox(width: 14),
                  Expanded(child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                    Text(item['title'] as String,
                        style: const TextStyle(
                            color: NavExaTheme.textDark,
                            fontWeight: FontWeight.w700,
                            fontSize: 13)),
                    const SizedBox(height: 3),
                    Text(item['desc'] as String,
                        style: const TextStyle(
                            color: NavExaTheme.textMid,
                            fontSize: 11, height: 1.4)),
                  ])),
                ]),
              ),
            )).toList(),
          ]),
        ),
      ),
    );
  }

  Widget _infoCard({required String title, required IconData icon,
      required Color color, required String content}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: NavExaTheme.cardBg,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color.withOpacity(0.2)),
        boxShadow: [BoxShadow(
            color: color.withOpacity(0.06),
            blurRadius: 8, offset: const Offset(0, 4))],
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(children: [
          Icon(icon, color: color, size: 16),
          const SizedBox(width: 8),
          Text(title, style: TextStyle(
              color: color, fontWeight: FontWeight.w800, fontSize: 14)),
        ]),
        const SizedBox(height: 8),
        Text(content, style: const TextStyle(
            color: NavExaTheme.textMid, fontSize: 13, height: 1.6)),
      ]),
    );
  }

  List<Map<String, dynamic>> _techItems() => [
    {
      'icon': Icons.satellite,
      'title': 'NavIC / IRNSS',
      'desc': 'Indian Regional Navigation Satellite System — 7 satellites for South Asia coverage',
      'color': NavExaTheme.brand,
      'bg': NavExaTheme.brand.withOpacity(0.08),
    },
    {
      'icon': Icons.psychology,
      'title': 'AI Dead Reckoning',
      'desc': 'ML models + IMU fusion to predict position when GPS is unavailable',
      'color': NavExaTheme.accentOlive,
      'bg': NavExaTheme.accentOlive.withOpacity(0.08),
    },
    {
      'icon': Icons.sensors,
      'title': 'IMU Sensor Fusion',
      'desc': 'Accelerometer + gyroscope data fused with AI for accurate position estimation',
      'color': NavExaTheme.accentTeal,
      'bg': NavExaTheme.accentTeal.withOpacity(0.08),
    },
    {
      'icon': Icons.gps_fixed,
      'title': 'GPS Loss Detection',
      'desc': 'Detects GPS denial in real-time and seamlessly switches navigation mode',
      'color': NavExaTheme.accentGreen,
      'bg': NavExaTheme.accentGreen.withOpacity(0.08),
    },
  ];
}

class _HeroBadge extends StatelessWidget {
  final String label;
  const _HeroBadge({required this.label});
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: BoxDecoration(
          color: Colors.white24, borderRadius: BorderRadius.circular(20)),
      child: Text(label, style: const TextStyle(
          color: Colors.white, fontSize: 11, fontWeight: FontWeight.w600)),
    );
  }
}
