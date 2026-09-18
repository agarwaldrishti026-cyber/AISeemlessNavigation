import 'package:flutter/material.dart';

class AnalyticsScreen extends StatelessWidget {
  const AnalyticsScreen({super.key});

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
            const Text('Analytics',
                style: TextStyle(
                    color: Colors.white, fontWeight: FontWeight.w700)),
          ],
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(18),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Summary cards
              Row(
                children: [
                  _SummaryCard(
                    label: 'GPS Uptime',
                    value: '94.2%',
                    icon: Icons.gps_fixed,
                    color: Colors.green,
                  ),
                  const SizedBox(width: 12),
                  _SummaryCard(
                    label: 'Loss Events',
                    value: '3',
                    icon: Icons.gps_off,
                    color: Colors.red,
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  _SummaryCard(
                    label: 'AI Coverage',
                    value: '100%',
                    icon: Icons.psychology,
                    color: Colors.purple,
                  ),
                  const SizedBox(width: 12),
                  _SummaryCard(
                    label: 'Avg Accuracy',
                    value: '±3.2m',
                    icon: Icons.my_location,
                    color: Colors.orange,
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // GPS Accuracy chart
              const Text('GPS Accuracy Over Time',
                  style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                      fontSize: 15)),
              const SizedBox(height: 12),
              _buildAccuracyChart(),
              const SizedBox(height: 24),

              // Signal events
              const Text('Signal Loss Events',
                  style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                      fontSize: 15)),
              const SizedBox(height: 12),
              ..._buildEventList(),
              const SizedBox(height: 24),

              // Navigation mode breakdown
              const Text('Navigation Mode Breakdown',
                  style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                      fontSize: 15)),
              const SizedBox(height: 12),
              _buildModeBreakdown(),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAccuracyChart() {
    final data = [2.1, 2.8, 3.5, 2.4, 8.2, 9.1, 3.0, 2.5, 2.2, 2.9];
    final maxVal = data.reduce((a, b) => a > b ? a : b);

    return Container(
      height: 160,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF0A1628),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFF1A2F50)),
      ),
      child: Column(
        children: [
          Expanded(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: data.asMap().entries.map((e) {
                final isHigh = e.value > 5;
                return Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Container(
                      width: 22,
                      height: 100 * (e.value / maxVal),
                      decoration: BoxDecoration(
                        color: isHigh
                            ? Colors.red.withOpacity(0.7)
                            : const Color(0xFF1A6FFF).withOpacity(0.7),
                        borderRadius: const BorderRadius.vertical(
                            top: Radius.circular(4)),
                      ),
                    ),
                  ],
                );
              }).toList(),
            ),
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: List.generate(
                data.length, (i) => Text('T${i + 1}',
                    style: const TextStyle(
                        color: Color(0xFF64B5F6), fontSize: 9))),
          ),
        ],
      ),
    );
  }

  List<Widget> _buildEventList() {
    final events = [
      {
        'time': '14:23:05',
        'duration': '47s',
        'type': 'Tunnel — AI DR Active',
        'status': 'Recovered',
      },
      {
        'time': '11:08:41',
        'duration': '22s',
        'type': 'Urban Canyon — Multipath',
        'status': 'Recovered',
      },
      {
        'time': '09:15:12',
        'duration': '63s',
        'type': 'Tunnel — AI DR Active',
        'status': 'Recovered',
      },
    ];

    return events.map((e) {
      return Container(
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: const Color(0xFF0A1628),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.red.withOpacity(0.2)),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.red.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child:
                  const Icon(Icons.warning_amber, color: Colors.red, size: 18),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(e['type']!,
                      style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                          fontSize: 13)),
                  Text('${e['time']}  ·  Duration: ${e['duration']}',
                      style: const TextStyle(
                          color: Color(0xFF64B5F6), fontSize: 11)),
                ],
              ),
            ),
            Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
              decoration: BoxDecoration(
                color: Colors.green.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.green.withOpacity(0.3)),
              ),
              child: Text(e['status']!,
                  style: const TextStyle(
                      color: Colors.green, fontSize: 10)),
            ),
          ],
        ),
      );
    }).toList();
  }

  Widget _buildModeBreakdown() {
    final modes = [
      {'label': 'NavIC / GPS', 'pct': 0.942, 'color': const Color(0xFF1A6FFF)},
      {'label': 'AI Dead Reckoning', 'pct': 0.058, 'color': Colors.purple},
    ];

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF0A1628),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFF1A2F50)),
      ),
      child: Column(
        children: (modes as List<Map<String, dynamic>>).map((m) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(m['label'] as String,
                        style: const TextStyle(
                            color: Colors.white, fontSize: 13)),
                    Text(
                        '${((m['pct'] as double) * 100).toStringAsFixed(1)}%',
                        style: TextStyle(
                            color: m['color'] as Color,
                            fontWeight: FontWeight.w700)),
                  ],
                ),
                const SizedBox(height: 6),
                ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: LinearProgressIndicator(
                    value: m['pct'] as double,
                    minHeight: 8,
                    backgroundColor: (m['color'] as Color).withOpacity(0.1),
                    valueColor: AlwaysStoppedAnimation<Color>(
                        m['color'] as Color),
                  ),
                ),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }
}

class _SummaryCard extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;
  final Color color;

  const _SummaryCard(
      {required this.label,
      required this.value,
      required this.icon,
      required this.color});

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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, color: color, size: 22),
            const SizedBox(height: 10),
            Text(value,
                style: TextStyle(
                    color: color,
                    fontSize: 22,
                    fontWeight: FontWeight.w800)),
            const SizedBox(height: 4),
            Text(label,
                style: const TextStyle(
                    color: Color(0xFF64B5F6), fontSize: 11)),
          ],
        ),
      ),
    );
  }
}
