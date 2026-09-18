import 'package:flutter/material.dart';
import 'dart:async';

class TunnelScreen extends StatefulWidget {
  const TunnelScreen({super.key});

  @override
  State<TunnelScreen> createState() => _TunnelScreenState();
}

class _TunnelScreenState extends State<TunnelScreen>
    with SingleTickerProviderStateMixin {
  // State
  String _gpsStatus = 'CONNECTED';
  String _navMode = 'NavIC / GPS';
  Color _statusColor = Colors.green;
  Color _modeColor = const Color(0xFF1A6FFF);
  bool _insideTunnel = false;
  bool _simComplete = false;

  // Simulated metrics
  double _aiConfidence = 0.0;
  double _distanceTravelled = 0.0;
  double _speed = 42.0;
  int _imuReadings = 0;
  Timer? _simTimer;

  // Animation
  late AnimationController _waveController;
  late Animation<double> _waveAnim;

  @override
  void initState() {
    super.initState();
    _waveController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);
    _waveAnim = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _waveController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _simTimer?.cancel();
    _waveController.dispose();
    super.dispose();
  }

  void _enterTunnel() {
    setState(() {
      _gpsStatus = 'LOST';
      _navMode = 'AI Dead Reckoning';
      _statusColor = Colors.red;
      _modeColor = Colors.purple;
      _insideTunnel = true;
      _simComplete = false;
      _aiConfidence = 0.72;
      _imuReadings = 0;
      _distanceTravelled = 0.0;
    });

    _simTimer?.cancel();
    _simTimer = Timer.periodic(const Duration(milliseconds: 500), (t) {
      if (!mounted) {
        t.cancel();
        return;
      }
      setState(() {
        _distanceTravelled += (_speed / 3600) * 0.5 * 1000;
        _imuReadings += 10;
        _aiConfidence =
            0.72 + (_distanceTravelled / 500) * 0.05 > 0.95
                ? 0.95
                : 0.72 + (_distanceTravelled / 500) * 0.05;
      });
    });
  }

  void _exitTunnel() {
    _simTimer?.cancel();
    setState(() {
      _gpsStatus = 'RECOVERED';
      _navMode = 'NavIC / GPS';
      _statusColor = Colors.green;
      _modeColor = const Color(0xFF1A6FFF);
      _insideTunnel = false;
      _simComplete = true;
    });

    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) {
        setState(() {
          _gpsStatus = 'CONNECTED';
          _simComplete = false;
        });
      }
    });
  }

  void _reset() {
    _simTimer?.cancel();
    setState(() {
      _gpsStatus = 'CONNECTED';
      _navMode = 'NavIC / GPS';
      _statusColor = Colors.green;
      _modeColor = const Color(0xFF1A6FFF);
      _insideTunnel = false;
      _simComplete = false;
      _aiConfidence = 0.0;
      _distanceTravelled = 0.0;
      _imuReadings = 0;
    });
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
            const Text('Tunnel Simulation',
                style: TextStyle(
                    color: Colors.white, fontWeight: FontWeight.w700)),
          ],
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(18),
          child: Column(
            children: [
              // Tunnel visual
              _buildTunnelVisual(),
              const SizedBox(height: 20),

              // Status card
              _buildStatusCard(),
              const SizedBox(height: 16),

              // AI Metrics (shown inside tunnel)
              if (_insideTunnel) ...[
                _buildAIMetrics(),
                const SizedBox(height: 16),
              ],

              // Simulation complete banner
              if (_simComplete)
                Container(
                  padding: const EdgeInsets.all(14),
                  margin: const EdgeInsets.only(bottom: 16),
                  decoration: BoxDecoration(
                    color: Colors.green.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.green.withOpacity(0.4)),
                  ),
                  child: const Row(
                    children: [
                      Icon(Icons.check_circle, color: Colors.green),
                      SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          'SIMULATION COMPLETE — GPS signal recovered. NavExa maintained continuous positioning.',
                          style: TextStyle(
                              color: Colors.green,
                              fontWeight: FontWeight.w600,
                              fontSize: 13),
                        ),
                      ),
                    ],
                  ),
                ),

              // Control buttons
              _buildControls(),
              const SizedBox(height: 20),

              // Info section
              _buildInfoSection(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTunnelVisual() {
    return AnimatedBuilder(
      animation: _waveAnim,
      builder: (_, __) {
        return Container(
          height: 160,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: _insideTunnel
                  ? [const Color(0xFF1A0030), const Color(0xFF0D0020)]
                  : [const Color(0xFF0D2458), const Color(0xFF0A1628)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: _insideTunnel
                  ? Colors.purple.withOpacity(0.4)
                  : const Color(0xFF1A6FFF).withOpacity(0.3),
            ),
          ),
          child: Stack(
            children: [
              // Tunnel arch visual
              CustomPaint(
                size: const Size(double.infinity, 160),
                painter: _TunnelPainter(
                    insideTunnel: _insideTunnel,
                    wave: _waveAnim.value),
              ),
              Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      _insideTunnel
                          ? Icons.do_not_disturb_on
                          : Icons.navigation,
                      size: 52,
                      color: _insideTunnel ? Colors.purple : const Color(0xFF1A6FFF),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      _insideTunnel ? 'INSIDE TUNNEL' : 'NavIC Based Intelligent Navigation',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: _insideTunnel ? Colors.purple[200] : const Color(0xFF64B5F6),
                        fontWeight: FontWeight.w700,
                        fontSize: _insideTunnel ? 16 : 13,
                        letterSpacing: _insideTunnel ? 2 : 0.5,
                      ),
                    ),
                    if (_insideTunnel)
                      Padding(
                        padding: const EdgeInsets.only(top: 4),
                        child: Text(
                          'AI Dead Reckoning Active',
                          style: TextStyle(
                              color: Colors.purple[300], fontSize: 11),
                        ),
                      ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildStatusCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF0A1628),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
            color: _statusColor.withOpacity(0.3)),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('GPS Status',
                      style: TextStyle(
                          color: Color(0xFF64B5F6), fontSize: 12)),
                  const SizedBox(height: 4),
                  Text(_gpsStatus,
                      style: TextStyle(
                          color: _statusColor,
                          fontSize: 26,
                          fontWeight: FontWeight.w800,
                          letterSpacing: 1)),
                ],
              ),
              Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: _statusColor.withOpacity(0.1),
                  border: Border.all(
                      color: _statusColor.withOpacity(0.4), width: 2),
                ),
                child: Icon(
                  _gpsStatus == 'CONNECTED' || _gpsStatus == 'RECOVERED'
                      ? Icons.gps_fixed
                      : Icons.gps_off,
                  color: _statusColor,
                ),
              ),
            ],
          ),
          const Divider(color: Color(0xFF1A2F50), height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Navigation Mode',
                  style:
                      TextStyle(color: Color(0xFF64B5F6), fontSize: 12)),
              Text(_navMode,
                  style: TextStyle(
                      color: _modeColor,
                      fontWeight: FontWeight.w700,
                      fontSize: 15)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildAIMetrics() {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: const Color(0xFF0A1628),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.purple.withOpacity(0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(Icons.psychology, color: Colors.purple, size: 18),
              SizedBox(width: 8),
              Text('AI + IMU Metrics',
                  style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w700)),
            ],
          ),
          const SizedBox(height: 16),
          _MetricRow(
              label: 'AI Confidence',
              value: '${(_aiConfidence * 100).toStringAsFixed(0)}%',
              color: Colors.purple),
          const SizedBox(height: 10),
          _MetricRow(
              label: 'Distance Traveled',
              value: '${_distanceTravelled.toStringAsFixed(1)} m',
              color: Colors.orange),
          const SizedBox(height: 10),
          _MetricRow(
              label: 'IMU Readings',
              value: '$_imuReadings',
              color: Colors.teal),
          const SizedBox(height: 10),
          _MetricRow(
              label: 'Speed',
              value: '${_speed.toStringAsFixed(0)} km/h',
              color: const Color(0xFF64B5F6)),
          const SizedBox(height: 14),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: _aiConfidence,
              minHeight: 6,
              backgroundColor: Colors.purple.withOpacity(0.15),
              valueColor:
                  const AlwaysStoppedAnimation<Color>(Colors.purple),
            ),
          ),
          const SizedBox(height: 6),
          Text('AI Position Estimation: ${(_aiConfidence * 100).toStringAsFixed(0)}% accuracy',
              style: TextStyle(color: Colors.purple[300], fontSize: 11)),
        ],
      ),
    );
  }

  Widget _buildControls() {
    return Column(
      children: [
        SizedBox(
          width: double.infinity,
          child: ElevatedButton.icon(
            onPressed: _insideTunnel ? null : _enterTunnel,
            icon: const Icon(Icons.arrow_downward),
            label: const Text('Enter Tunnel',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red.shade700,
              foregroundColor: Colors.white,
              disabledBackgroundColor: Colors.red.withOpacity(0.3),
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
            ),
          ),
        ),
        const SizedBox(height: 10),
        SizedBox(
          width: double.infinity,
          child: ElevatedButton.icon(
            onPressed: _insideTunnel ? _exitTunnel : null,
            icon: const Icon(Icons.arrow_upward),
            label: const Text('Exit Tunnel',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green.shade700,
              foregroundColor: Colors.white,
              disabledBackgroundColor: Colors.green.withOpacity(0.3),
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
            ),
          ),
        ),
        const SizedBox(height: 10),
        SizedBox(
          width: double.infinity,
          child: OutlinedButton.icon(
            onPressed: _reset,
            icon: const Icon(Icons.refresh),
            label: const Text('Reset Simulation',
                style: TextStyle(fontSize: 16)),
            style: OutlinedButton.styleFrom(
              foregroundColor: const Color(0xFF1A6FFF),
              side: const BorderSide(color: Color(0xFF1A6FFF)),
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildInfoSection() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF0A1628),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
            color: const Color(0xFF1A6FFF).withOpacity(0.15)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(Icons.info_outline, color: Color(0xFF64B5F6), size: 16),
              SizedBox(width: 8),
              Text('About This Simulation',
                  style: TextStyle(
                      color: Colors.white, fontWeight: FontWeight.w600)),
            ],
          ),
          const SizedBox(height: 10),
          const Text(
            'GPS signals can become unreliable or unavailable inside tunnels, underground parking areas and dense urban environments. When GPS is lost, NavExa uses AI-Enhanced Intelligent Dead Reckoning to continuously determine the vehicle\'s position.',
            style: TextStyle(
                color: Color(0xFF90CAF9), fontSize: 12, height: 1.6),
          ),
          const SizedBox(height: 10),
          const Text(
            'GPS is currently available. The vehicle is moving towards the tunnel.',
            style: TextStyle(
                color: Color(0xFF64B5F6),
                fontSize: 12,
                fontStyle: FontStyle.italic),
          ),
        ],
      ),
    );
  }
}

class _MetricRow extends StatelessWidget {
  final String label;
  final String value;
  final Color color;

  const _MetricRow(
      {required this.label, required this.value, required this.color});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label,
            style:
                const TextStyle(color: Color(0xFF64B5F6), fontSize: 13)),
        Text(value,
            style: TextStyle(
                color: color,
                fontWeight: FontWeight.w700,
                fontSize: 14)),
      ],
    );
  }
}

class _TunnelPainter extends CustomPainter {
  final bool insideTunnel;
  final double wave;

  _TunnelPainter({required this.insideTunnel, required this.wave});

  @override
  void paint(Canvas canvas, Size size) {
    if (!insideTunnel) return;

    // Draw tunnel arch
    final archPaint = Paint()
      ..color = Colors.purple.withOpacity(0.15)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;

    final path = Path();
    path.moveTo(size.width * 0.1, size.height);
    path.quadraticBezierTo(
        size.width * 0.5, -size.height * 0.2, size.width * 0.9, size.height);
    canvas.drawPath(path, archPaint);

    // Animated light effect
    final glowPaint = Paint()
      ..color = Colors.purple.withOpacity(0.05 + 0.05 * wave)
      ..maskFilter =
          const MaskFilter.blur(BlurStyle.normal, 20);
    canvas.drawOval(
      Rect.fromCenter(
          center: Offset(size.width / 2, size.height / 2),
          width: size.width * 0.6,
          height: size.height * 0.6),
      glowPaint,
    );
  }

  @override
  bool shouldRepaint(_TunnelPainter old) =>
      old.insideTunnel != insideTunnel || old.wave != wave;
}
