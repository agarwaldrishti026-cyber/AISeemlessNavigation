import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:http/http.dart' as http;
import 'package:latlong2/latlong.dart';

class RouteData {
  final List<LatLng> points;
  final double distanceKm;
  RouteData({required this.points, required this.distanceKm});
}

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  final MapController _mapController = MapController();
  final Map<String, RouteData> _routes = {};

  Timer? _timer;
  Timer? _tunnelNotificationTimer;

  bool _loadingRoutes = true;
  bool _simulationRunning = false;

  String _selectedRoute = '';
  bool _showSearchResults = false;

  double _remainingDistanceKm = 0.0;
  double _etaMinutes = 0.0;
  String _direction = '↑';
  String _turnInstruction = '';
  double _demoTotalDistanceKm = 0.0;

  static const double _simulatedSpeedKmh = 35.0;

  double _routeProgressIndex = 0.0;
  double _pointsPerTick = 1.0;
  int _currentPointIndex = 0;
  double _segmentProgress = 0.0;

  static const Duration _tickInterval = Duration(milliseconds: 50);
  static const double _simulationDurationSeconds = 120.0;

  int? _tunnelEntryIndex;
  int? _tunnelExitIndex;
  bool _tunnelEntryTriggered = false;
  bool _tunnelExitTriggered = false;
  String? _tunnelNotification;
  String _statusText = 'GPS SIMULATED';

  // ─── NavExa brand colours (bright theme) ─────────────────────────────────
  static const Color _brand       = Color(0xFF1A6FFF);
  static const Color _brandLight  = Color(0xFF4FC3F7);
  static const Color _accent      = Color(0xFF00E5FF);
  static const Color _cardBg      = Color(0xFFF0F6FF);  // light card
  static const Color _overlayBg   = Color(0xF0FFFFFF);  // white overlays
  static const Color _textDark    = Color(0xFF0D1B3E);
  static const Color _textMid     = Color(0xFF3A5080);
  // ─────────────────────────────────────────────────────────────────────────

  final Map<String, double> demoDistances = {
    'Hawa Mahal': 7.8,
    'Amer Fort (Amber Palace)': 11.6,
    'Atal Tunnel': 32.0,
    'Chenani-Nashri Tunnel': 18.0,
  };

  final Map<String, LatLng> locations = {
    'START': const LatLng(26.7677842, 75.8478009),
    'H': const LatLng(26.9239, 75.8267),
    'A': const LatLng(26.9855, 75.8513),
    'ATAL_START': const LatLng(32.3616586, 77.1327469),
    'ATAL_END': const LatLng(32.4395353, 77.1642992),
    'CHENANI_START': const LatLng(33.1031549, 75.2861579),
    'CHENANI_END': const LatLng(33.1309304, 75.2907839),
  };

  final Map<String, String> locationNames = {
    'START': 'Poornima Institute of Engineering and Technology',
    'H': 'Hawa Mahal',
    'A': 'Amer Fort (Amber Palace)',
    'ATAL_START': 'Atal Tunnel Entry',
    'ATAL_END': 'Atal Tunnel Exit',
    'CHENANI_START': 'Chenani-Nashri Tunnel Entry',
    'CHENANI_END': 'Chenani-Nashri Tunnel Exit',
  };

  final Map<String, List<String>> routePairs = {
    'Hawa Mahal': ['START', 'H'],
    'Amer Fort (Amber Palace)': ['START', 'A'],
    'Atal Tunnel': ['ATAL_START', 'ATAL_END'],
    'Chenani-Nashri Tunnel': ['CHENANI_START', 'CHENANI_END'],
  };

  final Map<String, Map<String, LatLng>> tunnelData = {
    'Atal Tunnel': {
      'entry': const LatLng(32.3616586, 77.1327469),
      'exit': const LatLng(32.4395353, 77.1642992),
    },
    'Chenani-Nashri Tunnel': {
      'entry': const LatLng(33.1031549, 75.2861579),
      'exit': const LatLng(33.1288333, 75.2928611),
    },
  };

  @override
  void initState() {
    super.initState();
    _loadAllRoutes();
  }

  Future<RouteData?> _getRoute(LatLng start, LatLng end) async {
    try {
      final url = Uri.parse(
        'https://router.project-osrm.org/route/v1/driving/'
        '${start.longitude},${start.latitude};'
        '${end.longitude},${end.latitude}'
        '?overview=full&geometries=geojson',
      );
      final response = await http.get(url);
      if (response.statusCode != 200) return null;
      final data = jsonDecode(response.body);
      final coordinates = data['routes'][0]['geometry']['coordinates'] as List;
      final distance = (data['routes'][0]['distance'] as num).toDouble() / 1000.0;
      final points = coordinates.map<LatLng>((c) => LatLng((c[1] as num).toDouble(), (c[0] as num).toDouble())).toList();
      return RouteData(points: points, distanceKm: distance);
    } catch (e) {
      debugPrint('Route error: $e');
      return null;
    }
  }

  Future<void> _loadAllRoutes() async {
    setState(() => _loadingRoutes = true);
    for (final entry in routePairs.entries) {
      final start = locations[entry.value[0]]!;
      final end = locations[entry.value[1]]!;
      final route = await _getRoute(start, end);
      if (route != null) _routes[entry.key] = route;
    }
    if (mounted) setState(() => _loadingRoutes = false);
  }

  int _findNearestPointIndex(List<LatLng> points, LatLng target) {
    int nearestIndex = 0;
    double nearestDist = double.infinity;
    for (int i = 0; i < points.length; i++) {
      final d = const Distance().as(LengthUnit.Meter, points[i], target);
      if (d < nearestDist) { nearestDist = d; nearestIndex = i; }
    }
    return nearestIndex;
  }

  void _triggerTunnelNotification(String text, {required bool entering}) {
    _tunnelNotificationTimer?.cancel();
    setState(() {
      _tunnelNotification = text;
      _statusText = entering ? 'AI CONNECTED' : 'GPS SIMULATED';
    });
    _tunnelNotificationTimer = Timer(const Duration(seconds: 3), () {
      if (!mounted) return;
      setState(() => _tunnelNotification = null);
    });
  }

  void _startSimulation() {
    if (_selectedRoute.isEmpty) return;
    final route = _routes[_selectedRoute];
    if (route == null || route.points.length < 2) return;

    final double demoDistance = demoDistances[_selectedRoute] ?? 10.0;
    _timer?.cancel();
    _tunnelNotificationTimer?.cancel();

    double totalRouteDistanceMeters = 0.0;
    for (int i = 0; i < route.points.length - 1; i++) {
      totalRouteDistanceMeters += const Distance().as(LengthUnit.Meter, route.points[i], route.points[i + 1]);
    }

    final int totalTicks = (_simulationDurationSeconds * 1000 / _tickInterval.inMilliseconds).round();
    double distancePerTickMeters = totalRouteDistanceMeters / totalTicks.clamp(1, 100000);
    if (_selectedRoute == 'Atal Tunnel') distancePerTickMeters *= 1.5;

    int? tunnelEntryIndex;
    int? tunnelExitIndex;
    final tunnelInfo = tunnelData[_selectedRoute];
    if (tunnelInfo != null) {
      tunnelEntryIndex = _findNearestPointIndex(route.points, tunnelInfo['entry']!);
      tunnelExitIndex = _findNearestPointIndex(route.points, tunnelInfo['exit']!);
      if (_selectedRoute == 'Chenani-Nashri Tunnel') tunnelEntryIndex = 0;
    }

    final List<double> cumulativeDistances = [0.0];
    for (int i = 1; i < route.points.length; i++) {
      final d = const Distance().as(LengthUnit.Meter, route.points[i - 1], route.points[i]);
      cumulativeDistances.add(cumulativeDistances.last + d);
    }

    setState(() {
      _simulationRunning = true;
      _routeProgressIndex = 0.0;
      _pointsPerTick = 0.0;
      _currentPointIndex = 0;
      _segmentProgress = 0.0;
      _demoTotalDistanceKm = demoDistance;
      _remainingDistanceKm = demoDistance;
      _etaMinutes = (demoDistance / _simulatedSpeedKmh) * 60.0;
      _direction = '↑';
      _turnInstruction = '';
      _tunnelEntryIndex = tunnelEntryIndex;
      _tunnelExitIndex = tunnelExitIndex;
      _tunnelEntryTriggered = false;
      _tunnelExitTriggered = false;
      _tunnelNotification = null;
      _statusText = 'GPS SIMULATED';
    });

    double traveledDistanceMeters = 0.0;

    _timer = Timer.periodic(_tickInterval, (timer) {
      if (!mounted) { timer.cancel(); return; }

      traveledDistanceMeters += distancePerTickMeters;

      if (traveledDistanceMeters >= totalRouteDistanceMeters) {
        traveledDistanceMeters = totalRouteDistanceMeters;
        if (_tunnelExitIndex != null && !_tunnelExitTriggered && _currentPointIndex >= _tunnelExitIndex!) {
          _tunnelExitTriggered = true;
          _triggerTunnelNotification('EXITED FROM TUNNEL', entering: false);
        }
        timer.cancel();
        setState(() {
          _simulationRunning = false;
          _routeProgressIndex = (route.points.length - 1).toDouble();
          _currentPointIndex = route.points.length - 2;
          _segmentProgress = 1.0;
          _remainingDistanceKm = 0.0;
          _etaMinutes = 0.0;
          _turnInstruction = '';
        });
        return;
      }

      int segmentIndex = 0;
      while (segmentIndex < cumulativeDistances.length - 2 &&
          cumulativeDistances[segmentIndex + 1] < traveledDistanceMeters) {
        segmentIndex++;
      }

      final double segLen = cumulativeDistances[segmentIndex + 1] - cumulativeDistances[segmentIndex];
      double segProg = segLen > 0 ? (traveledDistanceMeters - cumulativeDistances[segmentIndex]) / segLen : 0.0;
      segProg = segProg.clamp(0.0, 1.0);

      _currentPointIndex = segmentIndex;
      _segmentProgress = segProg;

      final start = route.points[segmentIndex];
      final end = route.points[segmentIndex + 1];
      final currentPosition = LatLng(
        start.latitude + (end.latitude - start.latitude) * segProg,
        start.longitude + (end.longitude - start.longitude) * segProg,
      );

      final double fractionComplete = (traveledDistanceMeters / totalRouteDistanceMeters).clamp(0.0, 1.0);
      final double displayRemainingKm = (_demoTotalDistanceKm * (1.0 - fractionComplete)).clamp(0.0, _demoTotalDistanceKm);

      if (_tunnelEntryIndex != null && !_tunnelEntryTriggered && _currentPointIndex >= _tunnelEntryIndex!) {
        _tunnelEntryTriggered = true;
        Timer(const Duration(seconds: 10), () {
          if (!mounted || !_simulationRunning) return;
          _triggerTunnelNotification('ENTERED IN TUNNEL', entering: true);
        });
      }

      if (_tunnelExitIndex != null && !_tunnelExitTriggered && _currentPointIndex >= _tunnelExitIndex!) {
        _tunnelExitTriggered = true;
        _triggerTunnelNotification('EXITED FROM TUNNEL', entering: false);
      }

      setState(() {
        _remainingDistanceKm = displayRemainingKm;
        _etaMinutes = (displayRemainingKm / _simulatedSpeedKmh) * 60.0;
        _direction = _calculateDirection(route);
        _turnInstruction = _getTurnInstruction(route);
      });

      _mapController.move(currentPosition, _mapController.camera.zoom);
    });
  }

  void _stopSimulation() {
    _timer?.cancel();
    _tunnelNotificationTimer?.cancel();
    setState(() {
      _simulationRunning = false;
      _routeProgressIndex = 0.0;
      _currentPointIndex = 0;
      _segmentProgress = 0.0;
      _remainingDistanceKm = 0.0;
      _etaMinutes = 0.0;
      _direction = '↑';
      _turnInstruction = '';
      _tunnelEntryIndex = null;
      _tunnelExitIndex = null;
      _tunnelEntryTriggered = false;
      _tunnelExitTriggered = false;
      _tunnelNotification = null;
      _statusText = 'GPS SIMULATED';
    });
  }

  void _selectRoute(String routeName) {
    _timer?.cancel();
    _tunnelNotificationTimer?.cancel();
    setState(() {
      _selectedRoute = routeName;
      _routeProgressIndex = 0.0;
      _currentPointIndex = 0;
      _segmentProgress = 0.0;
      _simulationRunning = false;
      _remainingDistanceKm = 0.0;
      _etaMinutes = 0.0;
      _turnInstruction = '';
      _tunnelNotification = null;
      _statusText = 'GPS SIMULATED';
    });
  }

  double? _lookAheadTurnAngle(RouteData route, double lookAheadSeconds) {
    final points = route.points;
    if (_currentPointIndex + 3 >= points.length) return null;
    final double lookAheadDistanceKm = _simulatedSpeedKmh * lookAheadSeconds / 3600;
    double distanceAhead = 0.0;
    int i = _currentPointIndex;
    while (i < points.length - 3 && i < _currentPointIndex + 60 && distanceAhead < lookAheadDistanceKm) {
      distanceAhead += const Distance().as(LengthUnit.Kilometer, points[i], points[i + 1]);
      final bearing1 = const Distance().bearing(points[i], points[i + 1]);
      final bearing2 = const Distance().bearing(points[i + 1], points[i + 2]);
      double turnAngle = bearing2 - bearing1;
      if (turnAngle > 180) turnAngle -= 360;
      if (turnAngle < -180) turnAngle += 360;
      if (turnAngle.abs() >= 35) return turnAngle;
      i++;
    }
    return null;
  }

  String _calculateDirection(RouteData route) {
    final double? a = _lookAheadTurnAngle(route, 10.0);
    if (a == null) return '↑';
    if (a.abs() > 150) return '↻';
    return a > 0 ? '↱' : '↰';
  }

  String _getTurnInstruction(RouteData route) {
    final double? a = _lookAheadTurnAngle(route, 5.0);
    if (a == null) return '';
    return a > 0 ? 'TURN RIGHT' : 'TURN LEFT';
  }

  // ─── Markers ─────────────────────────────────────────────────────────────

  Widget _locationMarker(String label, String name) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 38, height: 38,
          decoration: BoxDecoration(
            color: _brand,
            shape: BoxShape.circle,
            border: Border.all(color: Colors.white, width: 3),
            boxShadow: [BoxShadow(color: _brand.withOpacity(0.4), blurRadius: 10, spreadRadius: 2)],
          ),
          child: Center(child: Text(label, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14))),
        ),
        const SizedBox(height: 4),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
          decoration: BoxDecoration(
            color: _textDark.withOpacity(0.85),
            borderRadius: BorderRadius.circular(6),
          ),
          child: Text(name, style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.w600)),
        ),
      ],
    );
  }

  Widget _movingMarker() {
    return Container(
      width: 30, height: 30,
      decoration: BoxDecoration(
        color: _brand,
        shape: BoxShape.circle,
        border: Border.all(color: Colors.white, width: 3),
        boxShadow: [BoxShadow(color: _brand.withOpacity(0.7), blurRadius: 15, spreadRadius: 4)],
      ),
      child: const Icon(Icons.navigation, color: Colors.white, size: 17),
    );
  }

  List<Marker> _buildLocationMarkers() {
    if (_selectedRoute.isEmpty) return [];
    final routeKeys = routePairs[_selectedRoute];
    if (routeKeys == null || routeKeys.length < 2) return [];
    return routeKeys.map((key) => Marker(
      point: locations[key]!,
      width: 150, height: 90,
      child: _locationMarker(key, locationNames[key]!),
    )).toList();
  }

  List<Polyline> _buildPolylines() {
    return _routes.entries.map((entry) {
      final bool selected = entry.key == _selectedRoute;
      return Polyline(
        points: entry.value.points,
        color: selected ? _brand : _brand.withOpacity(0.25),
        strokeWidth: selected ? 6 : 3,
      );
    }).toList();
  }

  Marker? _buildMovingMarker() {
    final route = _routes[_selectedRoute];
    if (route == null || route.points.length < 2) return null;
    final index = _currentPointIndex.clamp(0, route.points.length - 2);
    final start = route.points[index];
    final end = route.points[index + 1];
    return Marker(
      point: LatLng(
        start.latitude + (end.latitude - start.latitude) * _segmentProgress,
        start.longitude + (end.longitude - start.longitude) * _segmentProgress,
      ),
      width: 45, height: 45,
      child: _movingMarker(),
    );
  }

  // ─── Overlay Widgets ──────────────────────────────────────────────────────

  Widget _navexaLogo() {
    return Container(
      width: 52, height: 52,
      padding: const EdgeInsets.all(5),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [BoxShadow(color: _brand.withOpacity(0.25), blurRadius: 12, spreadRadius: 2)],
        border: Border.all(color: _brand.withOpacity(0.3)),
      ),
      child: Image.asset(
        'assets/images/navexa_logo.jpeg',
        fit: BoxFit.contain,
        errorBuilder: (_, __, ___) => const Icon(Icons.navigation, color: Color(0xFF1A6FFF)),
      ),
    );
  }

  Widget _statusBox() {
    final bool isAi = _statusText == 'AI CONNECTED';
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.12), blurRadius: 10)],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text('STATUS', style: TextStyle(color: _textMid, fontSize: 10, fontWeight: FontWeight.bold, letterSpacing: 1)),
          const SizedBox(height: 3),
          Text(
            '● $_statusText',
            style: TextStyle(
              color: isAi ? const Color(0xFF00C853) : _brand,
              fontSize: 12,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _searchBar() {
    return GestureDetector(
      onTap: () => setState(() => _showSearchResults = !_showSearchResults),
      child: Container(
        height: 52,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.12), blurRadius: 12)],
          border: Border.all(color: _brand.withOpacity(0.2)),
        ),
        child: Row(
          children: [
            const SizedBox(width: 15),
            Icon(Icons.search, color: _brand, size: 22),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                _selectedRoute.isEmpty ? 'Search / Select Destination' : _selectedRoute,
                style: TextStyle(color: _selectedRoute.isEmpty ? _textMid : _textDark, fontSize: 14),
                overflow: TextOverflow.ellipsis,
              ),
            ),
            Icon(Icons.keyboard_arrow_down, color: _brand),
            const SizedBox(width: 10),
          ],
        ),
      ),
    );
  }

  Widget _destinationDropdown() {
    if (!_showSearchResults) return const SizedBox.shrink();
    final destinations = ['Hawa Mahal', 'Amer Fort (Amber Palace)', 'Atal Tunnel', 'Chenani-Nashri Tunnel'];
    return Container(
      margin: const EdgeInsets.only(top: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.15), blurRadius: 16)],
        border: Border.all(color: _brand.withOpacity(0.15)),
      ),
      child: Column(
        children: destinations.map((dest) {
          final bool isTunnel = dest.contains('Tunnel');
          return InkWell(
            onTap: () {
              _selectRoute(dest);
              setState(() => _showSearchResults = false);
            },
            borderRadius: BorderRadius.circular(16),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              child: Row(
                children: [
                  Icon(isTunnel ? Icons.merge_type : Icons.location_on, color: _brand, size: 20),
                  const SizedBox(width: 12),
                  Expanded(child: Text(dest, style: TextStyle(color: _textDark, fontSize: 14, fontWeight: FontWeight.w500))),
                  if (isTunnel)
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
                      decoration: BoxDecoration(
                        color: Colors.orange.withOpacity(0.12),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.orange.withOpacity(0.4)),
                      ),
                      child: const Text('TUNNEL', style: TextStyle(color: Colors.orange, fontSize: 9, fontWeight: FontWeight.bold)),
                    ),
                ],
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _navigationInfoBox() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [BoxShadow(color: _brand.withOpacity(0.15), blurRadius: 16, spreadRadius: 2)],
        border: Border.all(color: _brand.withOpacity(0.15)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('ETA', style: TextStyle(color: _textMid, fontSize: 11)),
                    const SizedBox(height: 3),
                    Text('${_etaMinutes.ceil()} min',
                        style: TextStyle(color: _textDark, fontSize: 18, fontWeight: FontWeight.bold)),
                  ],
                ),
              ),
              Container(width: 1, height: 38, color: _brand.withOpacity(0.2)),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(left: 18),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('REMAINING', style: TextStyle(color: _textMid, fontSize: 11)),
                      const SizedBox(height: 3),
                      Text('${_remainingDistanceKm.toStringAsFixed(1)} km',
                          style: TextStyle(color: _textDark, fontSize: 18, fontWeight: FontWeight.bold)),
                    ],
                  ),
                ),
              ),
              Container(
                width: 52, height: 52,
                decoration: BoxDecoration(color: _brand, borderRadius: BorderRadius.circular(16),
                  boxShadow: [BoxShadow(color: _brand.withOpacity(0.4), blurRadius: 8)]),
                child: Center(child: Text(_direction,
                    style: const TextStyle(color: Colors.white, fontSize: 28, fontWeight: FontWeight.bold))),
              ),
            ],
          ),
          if (_turnInstruction.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(top: 10),
              child: Align(
                alignment: Alignment.center,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                  decoration: BoxDecoration(
                    color: _brand.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: _brand.withOpacity(0.3)),
                  ),
                  child: Text(_turnInstruction,
                      style: TextStyle(color: _brand, fontSize: 13, fontWeight: FontWeight.bold, letterSpacing: 1)),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _tunnelNotificationBanner() {
    if (_tunnelNotification == null) return const SizedBox.shrink();
    final bool entering = _tunnelNotification!.contains('ENTERED');
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        color: entering ? const Color(0xFFFF6F00) : const Color(0xFF00C853),
        borderRadius: BorderRadius.circular(14),
        boxShadow: [BoxShadow(
          color: (entering ? Colors.orange : Colors.green).withOpacity(0.4),
          blurRadius: 12,
        )],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(entering ? Icons.warning_amber_rounded : Icons.check_circle, color: Colors.white, size: 18),
          const SizedBox(width: 8),
          Text(_tunnelNotification!,
              style: const TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.bold, letterSpacing: 1)),
        ],
      ),
    );
  }

  // ─── BUILD ────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _cardBg,
      body: SafeArea(
        child: Stack(
          children: [
            // MAP
            FlutterMap(
              mapController: _mapController,
              options: const MapOptions(
                initialCenter: LatLng(26.945, 75.825),
                initialZoom: 11.6,
              ),
              children: [
                TileLayer(
                  urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                  userAgentPackageName: 'com.navexa.app',
                ),
                PolylineLayer(polylines: _buildPolylines()),
                if (_selectedRoute.isNotEmpty)
                  MarkerLayer(markers: [
                    ..._buildLocationMarkers(),
                    if (_buildMovingMarker() != null) _buildMovingMarker()!,
                  ]),
              ],
            ),

            // LOGO (before start)
            if (!_simulationRunning)
              Positioned(top: 18, left: 18, child: _navexaLogo()),

            // STATUS (top-right before start)
            if (!_simulationRunning)
              Positioned(top: 18, right: 18, child: _statusBox()),

            // SEARCH (before start)
            if (!_simulationRunning)
              Positioned(
                top: 84, left: 18, right: 18,
                child: Column(children: [_searchBar(), _destinationDropdown()]),
              ),

            // NAVIGATION UI (while navigating)
            if (_simulationRunning)
              Positioned(
                top: 18, left: 18, right: 18,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _navigationInfoBox(),
                    const SizedBox(height: 10),
                    _statusBox(),
                    if (_tunnelNotification != null) ...[
                      const SizedBox(height: 10),
                      _tunnelNotificationBanner(),
                    ],
                  ],
                ),
              ),

            // LOADING
            if (_loadingRoutes)
              Center(
                child: Container(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [BoxShadow(color: _brand.withOpacity(0.2), blurRadius: 20)],
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      CircularProgressIndicator(color: _brand),
                      const SizedBox(height: 14),
                      Text('Loading routes...', style: TextStyle(color: _textDark, fontWeight: FontWeight.w600)),
                    ],
                  ),
                ),
              ),

            // START / STOP BUTTON
            if (_selectedRoute.isNotEmpty)
              Positioned(
                left: 18, right: 18, bottom: 18,
                child: SizedBox(
                  height: 52,
                  child: ElevatedButton.icon(
                    onPressed: _loadingRoutes ? null : (_simulationRunning ? _stopSimulation : _startSimulation),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _simulationRunning ? Colors.red.shade600 : _brand,
                      foregroundColor: Colors.white,
                      elevation: 4,
                      shadowColor: (_simulationRunning ? Colors.red : _brand).withOpacity(0.4),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                    ),
                    icon: Icon(_simulationRunning ? Icons.stop : Icons.navigation),
                    label: Text(
                      _simulationRunning ? 'STOP' : 'START NAVIGATION',
                      style: const TextStyle(fontWeight: FontWeight.bold, letterSpacing: 1, fontSize: 15),
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _timer?.cancel();
    _tunnelNotificationTimer?.cancel();
    super.dispose();
  }
}
