import 'package:flutter/material.dart';
import '../theme.dart';

class AnalyticsScreen extends StatelessWidget {
  const AnalyticsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: NavExaTheme.bg,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Row(children: [
          Container(width: 32, height: 32, decoration: const BoxDecoration(shape: BoxShape.circle),
            child: ClipOval(child: Image.asset('assets/images/navexa_logo.jpeg', fit: BoxFit.cover))),
          const SizedBox(width: 10),
          const Text('Analytics', style: TextStyle(color: NavExaTheme.textDark, fontWeight: FontWeight.w700)),
        ]),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(18),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(children: [
                _SummaryCard(label: 'GPS Uptime', value: '94.2%', icon: Icons.gps_fixed, color: NavExaTheme.accentGreen, bg: const Color(0xFFE8F5E9)),
                const SizedBox(width: 12),
                _SummaryCard(label: 'Loss Events', value: '3', icon: Icons.gps_off, color: Colors.red, bg: const Color(0xFFFFEBEE)),
              ]),
              const SizedBox(height: 12),
              Row(children: [
                _SummaryCard(label: 'AI Coverage', value: '100%', icon: Icons.psychology, color: NavExaTheme.accentPurple, bg: const Color(0xFFEDE7F6)),
                const SizedBox(width: 12),
                _SummaryCard(label: 'Avg Accuracy', value: '±3.2m', icon: Icons.my_location, color: NavExaTheme.accentOrange, bg: const Color(0xFFFFF3E0)),
              ]),
              const SizedBox(height: 24),

              const Text('GPS Accuracy Over Time',
                  style: TextStyle(color: NavExaTheme.textDark, fontWeight: FontWeight.w700, fontSize: 15)),
              const SizedBox(height: 12),
              _buildAccuracyChart(),
              const SizedBox(height: 24),

              const Text('Signal Loss Events',
                  style: TextStyle(color: NavExaTheme.textDark, fontWeight: FontWeight.w700, fontSize: 15)),
              const SizedBox(height: 12),
              ..._buildEventList(),
              const SizedBox(height: 24),

              const Text('Navigation Mode Breakdown',
                  style: TextStyle(color: NavExaTheme.textDark, fontWeight: FontWeight.w700, fontSize: 15)),
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
    final labels = ['T1','T2','T3','T4','T5','T6','T7','T8','T9','T10'];

    return Container(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: NavExaTheme.cardBorder),
        boxShadow: [BoxShadow(color: NavExaTheme.brand.withOpacity(0.06), blurRadius: 12, offset: const Offset(0, 4))],
      ),
      child: Column(
        children: [
          // y-axis labels + bars
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              // y labels
              Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: ['10','5','0'].map((l) =>
                  Padding(padding: const EdgeInsets.only(right: 8),
                    child: Text(l, style: const TextStyle(color: NavExaTheme.textLight, fontSize: 9)))).toList(),
              ),
              // bars
              Expanded(
                child: SizedBox(
                  height: 120,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: data.asMap().entries.map((e) {
                      final isHigh = e.value > 5;
                      final barColor = isHigh ? Colors.red.shade400 : NavExaTheme.brand;
                      final barBg = isHigh ? const Color(0xFFFFEBEE) : const Color(0xFFE8F0FF);
                      return Expanded(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 2),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              // value label on top
                              Text(e.value.toStringAsFixed(1),
                                  style: TextStyle(fontSize: 7, color: barColor, fontWeight: FontWeight.bold)),
                              const SizedBox(height: 2),
                              Container(
                                height: 110 * (e.value / maxVal),
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    colors: [barColor, barBg],
                                    begin: Alignment.topCenter,
                                    end: Alignment.bottomCenter,
                                  ),
                                  borderRadius: const BorderRadius.vertical(top: Radius.circular(5)),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              const SizedBox(width: 26),
              ...data.asMap().entries.map((e) =>
                Expanded(child: Text(labels[e.key],
                    textAlign: TextAlign.center,
                    style: const TextStyle(color: NavExaTheme.textLight, fontSize: 9)))),
            ],
          ),
          const SizedBox(height: 8),
          Row(children: [
            const SizedBox(width: 26),
            _LegendDot(color: NavExaTheme.brand, label: 'Normal'),
            const SizedBox(width: 12),
            _LegendDot(color: Colors.red, label: 'Signal Loss'),
          ]),
        ],
      ),
    );
  }

  List<Widget> _buildEventList() {
    final events = [
      {'time': '14:23:05', 'duration': '47s', 'type': 'Tunnel — AI DR Active', 'status': 'Recovered'},
      {'time': '11:08:41', 'duration': '22s', 'type': 'Urban Canyon — Multipath', 'status': 'Recovered'},
      {'time': '09:15:12', 'duration': '63s', 'type': 'Tunnel — AI DR Active', 'status': 'Recovered'},
    ];
    return events.map((e) => Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.red.withOpacity(0.2)),
        boxShadow: [BoxShadow(color: Colors.red.withOpacity(0.06), blurRadius: 8, offset: const Offset(0, 3))],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(color: const Color(0xFFFFEBEE), borderRadius: BorderRadius.circular(10)),
            child: const Icon(Icons.warning_amber, color: Colors.red, size: 18),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(e['type']!, style: const TextStyle(color: NavExaTheme.textDark, fontWeight: FontWeight.w600, fontSize: 13)),
              Text('${e['time']}  ·  Duration: ${e['duration']}', style: const TextStyle(color: NavExaTheme.textMid, fontSize: 11)),
            ]),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: const Color(0xFFE8F5E9),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: NavExaTheme.accentGreen.withOpacity(0.4)),
            ),
            child: Text(e['status']!, style: const TextStyle(color: Color(0xFF00693E), fontSize: 10, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    )).toList();
  }

  Widget _buildModeBreakdown() {
    final modes = [
      {'label': 'NavIC / GPS', 'pct': 0.942, 'color': NavExaTheme.brand, 'bg': const Color(0xFFE8F0FF)},
      {'label': 'AI Dead Reckoning', 'pct': 0.058, 'color': NavExaTheme.accentPurple, 'bg': const Color(0xFFEDE7F6)},
    ];
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: NavExaTheme.cardBorder),
        boxShadow: [BoxShadow(color: NavExaTheme.brand.withOpacity(0.06), blurRadius: 10, offset: const Offset(0, 4))],
      ),
      child: Column(
        children: (modes as List<Map<String, dynamic>>).map((m) {
          final pct = m['pct'] as double;
          final color = m['color'] as Color;
          return Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                Row(children: [
                  Container(width: 10, height: 10, decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(3))),
                  const SizedBox(width: 8),
                  Text(m['label'] as String, style: const TextStyle(color: NavExaTheme.textDark, fontSize: 13, fontWeight: FontWeight.w600)),
                ]),
                Text('${(pct * 100).toStringAsFixed(1)}%', style: TextStyle(color: color, fontWeight: FontWeight.w800, fontSize: 15)),
              ]),
              const SizedBox(height: 8),
              Stack(
                children: [
                  Container(height: 10, decoration: BoxDecoration(color: m['bg'] as Color, borderRadius: BorderRadius.circular(5))),
                  FractionallySizedBox(
                    widthFactor: pct,
                    child: Container(
                      height: 10,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(colors: [color, color.withOpacity(0.6)]),
                        borderRadius: BorderRadius.circular(5),
                        boxShadow: [BoxShadow(color: color.withOpacity(0.3), blurRadius: 6, offset: const Offset(0, 2))],
                      ),
                    ),
                  ),
                ],
              ),
            ]),
          );
        }).toList(),
      ),
    );
  }
}

class _SummaryCard extends StatelessWidget {
  final String label, value;
  final IconData icon;
  final Color color, bg;

  const _SummaryCard({required this.label, required this.value, required this.icon, required this.color, required this.bg});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: color.withOpacity(0.2)),
          boxShadow: [BoxShadow(color: color.withOpacity(0.1), blurRadius: 12, offset: const Offset(0, 4))],
        ),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Container(padding: const EdgeInsets.all(8), decoration: BoxDecoration(color: bg, borderRadius: BorderRadius.circular(10)),
            child: Icon(icon, color: color, size: 20)),
          const SizedBox(height: 10),
          Text(value, style: TextStyle(color: color, fontSize: 22, fontWeight: FontWeight.w900)),
          const SizedBox(height: 3),
          Text(label, style: const TextStyle(color: NavExaTheme.textMid, fontSize: 11)),
        ]),
      ),
    );
  }
}

class _LegendDot extends StatelessWidget {
  final Color color;
  final String label;
  const _LegendDot({required this.color, required this.label});

  @override
  Widget build(BuildContext context) {
    return Row(children: [
      Container(width: 10, height: 10, decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(3))),
      const SizedBox(width: 4),
      Text(label, style: const TextStyle(color: NavExaTheme.textMid, fontSize: 10)),
    ]);
  }
}
