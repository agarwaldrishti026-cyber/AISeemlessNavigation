import 'package:flutter/material.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF060E1E),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0A1628),
        elevation: 0,
        title: Row(
          children: [
            Container(
              width: 32,
              height: 32,
              decoration: const BoxDecoration(shape: BoxShape.circle),
              child: ClipOval(
                child: Image.asset('assets/images/navexa_logo.jpeg',
                    fit: BoxFit.cover),
              ),
            ),
            const SizedBox(width: 10),
            const Text('About NavExa',
                style: TextStyle(
                    color: Colors.white, fontWeight: FontWeight.w700)),
          ],
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              // Logo hero
              Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF1A6FFF).withOpacity(0.4),
                      blurRadius: 30,
                      spreadRadius: 5,
                    ),
                  ],
                ),
                child: ClipOval(
                  child: Image.asset('assets/images/navexa_logo.jpeg',
                      fit: BoxFit.cover),
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                'NavExa',
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.w900,
                  color: Colors.white,
                  letterSpacing: 3,
                ),
              ),
              const SizedBox(height: 6),
              const Text(
                'NAVIGATION BEYOND LIMITS',
                style: TextStyle(
                  color: Color(0xFF64B5F6),
                  fontSize: 12,
                  letterSpacing: 4,
                ),
              ),
              const SizedBox(height: 4),
              const Text(
                'NAVIC  |  AI  |  ALWAYS ON',
                style: TextStyle(
                  color: Color(0xFF7C83D6),
                  fontSize: 11,
                  letterSpacing: 3,
                ),
              ),
              const SizedBox(height: 30),

              // Mission
              _Section(
                title: 'About Project',
                content:
                    'NavExa is an AI-powered navigation prototype that leverages India\'s NavIC satellite system combined with intelligent dead reckoning to provide continuous, uninterrupted positioning — even in GPS-denied environments like tunnels, underground parking, and dense urban canyons.',
              ),
              const SizedBox(height: 16),

              // Key tech
              const Text('Key Technologies',
                  style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                      fontSize: 15)),
              const SizedBox(height: 12),
              ...[
                {
                  'icon': Icons.satellite,
                  'title': 'NavIC / IRNSS',
                  'desc': 'Indian Regional Navigation Satellite System with 7 satellites for South Asia coverage',
                  'color': const Color(0xFF1A6FFF),
                },
                {
                  'icon': Icons.psychology,
                  'title': 'AI Dead Reckoning',
                  'desc': 'Machine learning models combined with IMU sensor fusion to predict position when GPS is lost',
                  'color': Colors.purple,
                },
                {
                  'icon': Icons.sensors,
                  'title': 'IMU Sensor Fusion',
                  'desc': 'Accelerometer + gyroscope data fused with AI predictions for accurate position estimation',
                  'color': Colors.teal,
                },
                {
                  'icon': Icons.gps_fixed,
                  'title': 'GPS Loss Detection',
                  'desc': 'Detects when reliable GPS positioning is unavailable and seamlessly switches modes',
                  'color': Colors.orange,
                },
              ].map((item) => Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: Container(
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: const Color(0xFF0A1628),
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(
                            color: (item['color'] as Color).withOpacity(0.2)),
                      ),
                      child: Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: (item['color'] as Color).withOpacity(0.1),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Icon(item['icon'] as IconData,
                                color: item['color'] as Color, size: 22),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(item['title'] as String,
                                    style: const TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.w600,
                                        fontSize: 13)),
                                const SizedBox(height: 3),
                                Text(item['desc'] as String,
                                    style: const TextStyle(
                                        color: Color(0xFF64B5F6),
                                        fontSize: 11,
                                        height: 1.4)),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  )),
              const SizedBox(height: 16),

              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: const Color(0xFF0A1628),
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(
                      color: const Color(0xFF1A6FFF).withOpacity(0.2)),
                ),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _InfoBadge(label: 'Version', value: '1.0.0'),
                    _InfoBadge(label: 'Platform', value: 'Flutter'),
                    _InfoBadge(label: 'System', value: 'NavIC'),
                  ],
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}

class _Section extends StatelessWidget {
  final String title;
  final String content;

  const _Section({required this.title, required this.content});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF0A1628),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
            color: const Color(0xFF1A6FFF).withOpacity(0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title,
              style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w700,
                  fontSize: 15)),
          const SizedBox(height: 8),
          Text(content,
              style: const TextStyle(
                  color: Color(0xFF90CAF9), fontSize: 13, height: 1.6)),
        ],
      ),
    );
  }
}

class _InfoBadge extends StatelessWidget {
  final String label;
  final String value;

  const _InfoBadge({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(value,
            style: const TextStyle(
                color: Color(0xFF1A6FFF),
                fontWeight: FontWeight.w700,
                fontSize: 15)),
        const SizedBox(height: 2),
        Text(label,
            style: const TextStyle(
                color: Color(0xFF64B5F6), fontSize: 11)),
      ],
    );
  }
}
