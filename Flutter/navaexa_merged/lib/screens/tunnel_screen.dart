import 'package:flutter/material.dart';
import 'dart:async';
import '../theme.dart';

class TunnelScreen extends StatefulWidget {
  const TunnelScreen({super.key});
  @override
  State<TunnelScreen> createState() => _TunnelScreenState();
}

class _TunnelScreenState extends State<TunnelScreen>
    with SingleTickerProviderStateMixin {
  String _gpsStatus = 'CONNECTED';
  String _navMode = 'NavIC / GPS';
  Color _statusColor = NavExaTheme.accentGreen;
  Color _modeColor = NavExaTheme.brand;
  bool _insideTunnel = false;
  bool _simComplete = false;

  double _aiConfidence = 0.0;
  double _distanceTravelled = 0.0;
  double _speed = 42.0;
  int _imuReadings = 0;
  Timer? _simTimer;

  late AnimationController _waveCtrl;
  late Animation<double> _waveAnim;

  @override
  void initState() {
    super.initState();
    _waveCtrl = AnimationController(
        vsync: this, duration: const Duration(seconds: 2))
      ..repeat(reverse: true);
    _waveAnim = Tween<double>(begin: 0.0, end: 1.0).animate(
        CurvedAnimation(parent: _waveCtrl, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _simTimer?.cancel();
    _waveCtrl.dispose();
    super.dispose();
  }

  void _enterTunnel() {
    setState(() {
      _gpsStatus = 'LOST';
      _navMode = 'AI Dead Reckoning';
      _statusColor = NavExaTheme.accentTerra;
      _modeColor = NavExaTheme.accentOlive;
      _insideTunnel = true;
      _simComplete = false;
      _aiConfidence = 0.72;
      _imuReadings = 0;
      _distanceTravelled = 0.0;
    });
    _simTimer?.cancel();
    _simTimer = Timer.periodic(const Duration(milliseconds: 500), (t) {
      if (!mounted) { t.cancel(); return; }
      setState(() {
        _distanceTravelled += (_speed / 3600) * 0.5 * 1000;
        _imuReadings += 10;
        final next = 0.72 + (_distanceTravelled / 500) * 0.05;
        _aiConfidence = next > 0.95 ? 0.95 : next;
      });
    });
  }

  void _exitTunnel() {
    _simTimer?.cancel();
    setState(() {
      _gpsStatus = 'RECOVERED';
      _navMode = 'NavIC / GPS';
      _statusColor = NavExaTheme.accentGreen;
      _modeColor = NavExaTheme.brand;
      _insideTunnel = false;
      _simComplete = true;
    });
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) setState(() { _gpsStatus = 'CONNECTED'; _simComplete = false; });
    });
  }

  void _reset() {
    _simTimer?.cancel();
    setState(() {
      _gpsStatus = 'CONNECTED';
      _navMode = 'NavIC / GPS';
      _statusColor = NavExaTheme.accentGreen;
      _modeColor = NavExaTheme.brand;
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
      backgroundColor: NavExaTheme.bg,
      appBar: AppBar(
        backgroundColor: NavExaTheme.cardBg,
        elevation: 0,
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
          const Text('Tunnel Simulation',
              style: TextStyle(
                  color: NavExaTheme.textDark, fontWeight: FontWeight.w700)),
        ]),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(18),
          child: Column(children: [
            _buildTunnelVisual(),
            const SizedBox(height: 18),
            _buildStatusCard(),
            const SizedBox(height: 14),
            if (_insideTunnel) ...[_buildAIMetrics(), const SizedBox(height: 14)],
            if (_simComplete)
              Container(
                padding: const EdgeInsets.all(14),
                margin: const EdgeInsets.only(bottom: 14),
                decoration: BoxDecoration(
                  color: NavExaTheme.accentGreen.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                      color: NavExaTheme.accentGreen.withOpacity(0.4)),
                ),
                child: Row(children: [
                  const Icon(Icons.check_circle, color: NavExaTheme.accentGreen),
                  const SizedBox(width: 10),
                  const Expanded(child: Text(
                    'SIMULATION COMPLETE — GPS recovered. NavExa maintained continuous positioning.',
                    style: TextStyle(
                        color: NavExaTheme.accentGreen,
                        fontWeight: FontWeight.w600,
                        fontSize: 13),
                  )),
                ]),
              ),
            _buildControls(),
            const SizedBox(height: 18),
            _buildInfoSection(),
          ]),
        ),
      ),
    );
  }

  Widget _buildTunnelVisual() {
    return AnimatedBuilder(
      animation: _waveAnim,
      builder: (_, __) => Container(
        height: 160,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: _insideTunnel
                ? [const Color(0xFF2C1A4A), const Color(0xFF1A2C3A)]
                : [NavExaTheme.brand, const Color(0xFF1E5F74)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
                color: (_insideTunnel ? NavExaTheme.accentOlive : NavExaTheme.brand)
                    .withOpacity(0.3),
                blurRadius: 18,
                offset: const Offset(0, 6))
          ],
        ),
        child: Stack(children: [
          if (_insideTunnel)
            CustomPaint(
                size: const Size(double.infinity, 160),
                painter: _TunnelPainter(wave: _waveAnim.value)),
          Center(child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                _insideTunnel ? Icons.do_not_disturb_on : Icons.navigation,
                size: 52, color: Colors.white,
              ),
              const SizedBox(height: 8),
              Text(
                _insideTunnel ? 'INSIDE TUNNEL' : 'NavIC Based Intelligent Navigation',
                textAlign: TextAlign.center,
                style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w800,
                    fontSize: 14,
                    letterSpacing: 1),
              ),
              if (_insideTunnel)
                Padding(
                  padding: const EdgeInsets.only(top: 4),
                  child: Text('AI Dead Reckoning Active',
                      style: TextStyle(
                          color: Colors.white.withOpacity(0.7), fontSize: 11)),
                ),
            ],
          )),
        ]),
      ),
    );
  }

  Widget _buildStatusCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: NavExaTheme.cardBg,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: _statusColor.withOpacity(0.3)),
        boxShadow: [
          BoxShadow(
              color: _statusColor.withOpacity(0.08),
              blurRadius: 12,
              offset: const Offset(0, 4))
        ],
      ),
      child: Column(children: [
        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            const Text('GPS Status',
                style: TextStyle(color: NavExaTheme.textLight, fontSize: 12)),
            const SizedBox(height: 4),
            Text(_gpsStatus,
                style: TextStyle(
                    color: _statusColor,
                    fontSize: 26,
                    fontWeight: FontWeight.w900,
                    letterSpacing: 1)),
          ]),
          Container(
            width: 52, height: 52,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: _statusColor.withOpacity(0.1),
              border: Border.all(color: _statusColor.withOpacity(0.5), width: 2),
            ),
            child: Icon(
              _gpsStatus == 'CONNECTED' || _gpsStatus == 'RECOVERED'
                  ? Icons.gps_fixed : Icons.gps_off,
              color: _statusColor, size: 26),
          ),
        ]),
        Divider(color: NavExaTheme.cardBorder, height: 24),
        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          const Text('Navigation Mode',
              style: TextStyle(color: NavExaTheme.textLight, fontSize: 12)),
          Text(_navMode,
              style: TextStyle(
                  color: _modeColor,
                  fontWeight: FontWeight.w700,
                  fontSize: 15)),
        ]),
      ]),
    );
  }

  Widget _buildAIMetrics() {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: NavExaTheme.cardBg,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: NavExaTheme.accentOlive.withOpacity(0.3)),
        boxShadow: [
          BoxShadow(
              color: NavExaTheme.accentOlive.withOpacity(0.08),
              blurRadius: 12,
              offset: const Offset(0, 4))
        ],
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
                color: NavExaTheme.accentOlive.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8)),
            child: const Icon(Icons.psychology,
                color: NavExaTheme.accentOlive, size: 18),
          ),
          const SizedBox(width: 10),
          const Text('AI + IMU Metrics',
              style: TextStyle(
                  color: NavExaTheme.textDark,
                  fontWeight: FontWeight.w700,
                  fontSize: 15)),
        ]),
        const SizedBox(height: 16),
        _MetricRow(label: 'AI Confidence',
            value: '${(_aiConfidence * 100).toStringAsFixed(0)}%',
            color: NavExaTheme.accentOlive),
        const SizedBox(height: 10),
        _MetricRow(label: 'Distance Traveled',
            value: '${_distanceTravelled.toStringAsFixed(1)} m',
            color: NavExaTheme.accentTerra),
        const SizedBox(height: 10),
        _MetricRow(label: 'IMU Readings',
            value: '$_imuReadings',
            color: NavExaTheme.brand),
        const SizedBox(height: 10),
        _MetricRow(label: 'Speed',
            value: '${_speed.toStringAsFixed(0)} km/h',
            color: NavExaTheme.accentTeal),
        const SizedBox(height: 14),
        ClipRRect(
          borderRadius: BorderRadius.circular(6),
          child: LinearProgressIndicator(
            value: _aiConfidence,
            minHeight: 8,
            backgroundColor: NavExaTheme.accentOlive.withOpacity(0.12),
            valueColor: const AlwaysStoppedAnimation<Color>(
                NavExaTheme.accentOlive)),
        ),
        const SizedBox(height: 6),
        Text(
          'AI Position Estimation: ${(_aiConfidence * 100).toStringAsFixed(0)}% accuracy',
          style: const TextStyle(
              color: NavExaTheme.accentOlive,
              fontSize: 11,
              fontWeight: FontWeight.w500)),
      ]),
    );
  }

  Widget _buildControls() {
    return Column(children: [
      SizedBox(
        width: double.infinity,
        child: ElevatedButton.icon(
          onPressed: _insideTunnel ? null : _enterTunnel,
          icon: const Icon(Icons.arrow_downward),
          label: const Text('Enter Tunnel',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
          style: ElevatedButton.styleFrom(
            backgroundColor: NavExaTheme.accentTerra,
            foregroundColor: Colors.white,
            disabledBackgroundColor: NavExaTheme.accentTerra.withOpacity(0.25),
            elevation: 3,
            shadowColor: NavExaTheme.accentTerra.withOpacity(0.3),
            padding: const EdgeInsets.symmetric(vertical: 16),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14)),
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
            backgroundColor: NavExaTheme.accentGreen,
            foregroundColor: Colors.white,
            disabledBackgroundColor: NavExaTheme.accentGreen.withOpacity(0.25),
            elevation: 3,
            shadowColor: NavExaTheme.accentGreen.withOpacity(0.3),
            padding: const EdgeInsets.symmetric(vertical: 16),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14)),
          ),
        ),
      ),
      const SizedBox(height: 10),
      SizedBox(
        width: double.infinity,
        child: OutlinedButton.icon(
          onPressed: _reset,
          icon: const Icon(Icons.refresh),
          label: const Text('Reset Simulation', style: TextStyle(fontSize: 16)),
          style: OutlinedButton.styleFrom(
            foregroundColor: NavExaTheme.brand,
            side: const BorderSide(color: NavExaTheme.brand, width: 1.5),
            padding: const EdgeInsets.symmetric(vertical: 16),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14)),
          ),
        ),
      ),
    ]);
  }

  Widget _buildInfoSection() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: NavExaTheme.cardBg,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: NavExaTheme.cardBorder),
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        const Row(children: [
          Icon(Icons.info_outline, color: NavExaTheme.accentTeal, size: 16),
          SizedBox(width: 8),
          Text('About This Simulation',
              style: TextStyle(
                  color: NavExaTheme.textDark, fontWeight: FontWeight.w700)),
        ]),
        const SizedBox(height: 10),
        const Text(
          'When GPS is lost inside tunnels, NavExa uses AI-Enhanced Dead Reckoning combined with IMU sensor fusion to continuously determine the vehicle\'s position.',
          style: TextStyle(
              color: NavExaTheme.textMid, fontSize: 12, height: 1.6)),
      ]),
    );
  }
}

class _MetricRow extends StatelessWidget {
  final String label, value;
  final Color color;
  const _MetricRow({required this.label, required this.value, required this.color});
  @override
  Widget build(BuildContext context) {
    return Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
      Text(label, style: const TextStyle(color: NavExaTheme.textMid, fontSize: 13)),
      Text(value, style: TextStyle(color: color, fontWeight: FontWeight.w800, fontSize: 14)),
    ]);
  }
}

class _TunnelPainter extends CustomPainter {
  final double wave;
  _TunnelPainter({required this.wave});
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withOpacity(0.07 + 0.05 * wave)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;
    final path = Path()
      ..moveTo(size.width * 0.1, size.height)
      ..quadraticBezierTo(
          size.width * 0.5, -size.height * 0.1, size.width * 0.9, size.height);
    canvas.drawPath(path, paint);
  }
  @override
  bool shouldRepaint(_TunnelPainter old) => old.wave != wave;
}
