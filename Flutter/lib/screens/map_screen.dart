import 'package:flutter/material.dart';
import 'dart:math' as math;

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _pulseController;
  late Animation<double> _pulseAnim;

  // Simulated vehicle position (Jaipur coordinates)
  double _vehicleLat = 26.9124;
  double _vehicleLon = 75.7873;
  double _heading = 45.0;
  double _speed = 38.5;
  String _navMode = 'NavIC / GPS';
  bool _isTracking = true;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);
    _pulseAnim = Tween<double>(begin: 0.4, end: 1.0).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

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
            const Text('Live Map',
                style: TextStyle(
                    color: Colors.white, fontWeight: FontWeight.w700)),
          ],
        ),
        actions: [
          IconButton(
            icon: Icon(_isTracking ? Icons.gps_fixed : Icons.gps_not_fixed,
                color: _isTracking ? const Color(0xFF1A6FFF) : Colors.grey),
            onPressed: () => setState(() => _isTracking = !_isTracking),
          ),
        ],
      ),
      body: Stack(
        children: [
          // Map placeholder (OpenStreetMap-style dark map)
          _buildMapCanvas(),

          // Vehicle overlay
          Center(child: _buildVehicleMarker()),

          // Top info bar
          Positioned(
            top: 12,
            left: 12,
            right: 12,
            child: _buildInfoBar(),
          ),

          // Bottom nav card
          Positioned(
            bottom: 12,
            left: 12,
            right: 12,
            child: _buildNavCard(),
          ),
        ],
      ),
    );
  }

  Widget _buildMapCanvas() {
    return CustomPaint(
      size: Size.infinite,
      painter: _MapPainter(),
    );
  }

  Widget _buildVehicleMarker() {
    return AnimatedBuilder(
      animation: _pulseAnim,
      builder: (_, __) {
        return Stack(
          alignment: Alignment.center,
          children: [
            // Pulse ring
            Container(
              width: 60 * _pulseAnim.value,
              height: 60 * _pulseAnim.value,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: const Color(0xFF1A6FFF).withOpacity(0.2 * (1 - _pulseAnim.value + 0.5)),
                border: Border.all(
                  color: const Color(0xFF1A6FFF).withOpacity(0.5),
                  width: 1.5,
                ),
              ),
            ),
            // Vehicle icon
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: const Color(0xFF1A6FFF),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF1A6FFF).withOpacity(0.5),
                    blurRadius: 12,
                    spreadRadius: 2,
                  ),
                ],
              ),
              child: const Icon(Icons.navigation, color: Colors.white, size: 20),
            ),
          ],
        );
      },
    );
  }

  Widget _buildInfoBar() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: const Color(0xFF0A1628).withOpacity(0.9),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
            color: const Color(0xFF1A6FFF).withOpacity(0.3)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _InfoChip(
              icon: Icons.satellite_alt,
              label: '8 Sats',
              color: const Color(0xFF1A6FFF)),
          _InfoChip(
              icon: Icons.gps_fixed,
              label: 'GPS ±3m',
              color: Colors.green),
          _InfoChip(
              icon: Icons.speed,
              label: '${_speed.toStringAsFixed(0)} km/h',
              color: Colors.orange),
          _InfoChip(
              icon: Icons.explore,
              label: '${_heading.toStringAsFixed(0)}°',
              color: Colors.purple),
        ],
      ),
    );
  }

  Widget _buildNavCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF0A1628).withOpacity(0.95),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
            color: const Color(0xFF1A6FFF).withOpacity(0.3)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.4),
            blurRadius: 20,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              const Icon(Icons.route, color: Color(0xFF1A6FFF), size: 18),
              const SizedBox(width: 8),
              const Text('LIVE NAVIGATION DATA',
                  style: TextStyle(
                      color: Color(0xFF64B5F6),
                      fontSize: 11,
                      letterSpacing: 1.5,
                      fontWeight: FontWeight.w600)),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: Colors.green.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: Colors.green.withOpacity(0.4)),
                ),
                child: Text(_navMode,
                    style: const TextStyle(
                        color: Colors.green, fontSize: 10)),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: _NavStat(
                    label: 'Latitude',
                    value: _vehicleLat.toStringAsFixed(4)),
              ),
              Expanded(
                child: _NavStat(
                    label: 'Longitude',
                    value: _vehicleLon.toStringAsFixed(4)),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                child: _NavStat(label: 'Heading', value: '${_heading.toStringAsFixed(1)}°'),
              ),
              Expanded(
                child: _NavStat(label: 'ETA', value: '12 min'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _InfoChip extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;

  const _InfoChip(
      {required this.icon, required this.label, required this.color});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 14, color: color),
        const SizedBox(width: 4),
        Text(label,
            style: TextStyle(
                color: color, fontSize: 11, fontWeight: FontWeight.w600)),
      ],
    );
  }
}

class _NavStat extends StatelessWidget {
  final String label;
  final String value;

  const _NavStat({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,
            style: const TextStyle(color: Color(0xFF64B5F6), fontSize: 10)),
        const SizedBox(height: 2),
        Text(value,
            style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w700,
                fontSize: 14)),
      ],
    );
  }
}

// Custom painter for the dark map background
class _MapPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final bgPaint = Paint()..color = const Color(0xFF0D1B2E);
    canvas.drawRect(Rect.fromLTWH(0, 0, size.width, size.height), bgPaint);

    final roadPaint = Paint()
      ..color = const Color(0xFF1A2F50)
      ..strokeWidth = 8
      ..strokeCap = StrokeCap.round;

    final minorPaint = Paint()
      ..color = const Color(0xFF152340)
      ..strokeWidth = 4;

    final gridPaint = Paint()
      ..color = const Color(0xFF0F1E35)
      ..strokeWidth = 1;

    // Grid lines
    for (double x = 0; x < size.width; x += 40) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), gridPaint);
    }
    for (double y = 0; y < size.height; y += 40) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), gridPaint);
    }

    // Major roads
    final roads = [
      [Offset(0, size.height * 0.3), Offset(size.width, size.height * 0.45)],
      [Offset(0, size.height * 0.6), Offset(size.width, size.height * 0.55)],
      [Offset(size.width * 0.25, 0), Offset(size.width * 0.3, size.height)],
      [Offset(size.width * 0.7, 0), Offset(size.width * 0.65, size.height)],
    ];
    for (final r in roads) {
      canvas.drawLine(r[0], r[1], roadPaint);
    }

    // Minor roads
    final minor = [
      [Offset(0, size.height * 0.15), Offset(size.width * 0.3, size.height * 0.3)],
      [Offset(size.width * 0.3, size.height * 0.3), Offset(size.width * 0.7, size.height * 0.4)],
      [Offset(size.width * 0.3, size.height * 0.7), Offset(size.width, size.height * 0.75)],
      [Offset(size.width * 0.5, size.height * 0.45), Offset(size.width * 0.5, size.height * 0.6)],
    ];
    for (final r in minor) {
      canvas.drawLine(r[0], r[1], minorPaint);
    }

    // Route highlight
    final routePaint = Paint()
      ..color = const Color(0xFF1A6FFF).withOpacity(0.6)
      ..strokeWidth = 4
      ..strokeCap = StrokeCap.round;

    final path = Path();
    path.moveTo(size.width * 0.1, size.height * 0.6);
    path.quadraticBezierTo(size.width * 0.3, size.height * 0.45,
        size.width * 0.5, size.height * 0.5);
    path.quadraticBezierTo(size.width * 0.7, size.height * 0.4,
        size.width * 0.9, size.height * 0.35);
    canvas.drawPath(path, routePaint..style = PaintingStyle.stroke);
  }

  @override
  bool shouldRepaint(_) => false;
}
