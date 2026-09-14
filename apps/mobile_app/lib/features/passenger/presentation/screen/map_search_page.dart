import 'dart:async';
import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'package:latlong2/latlong.dart';

import '../../../../../core/theme/app_colors.dart';

class MapSearchPage extends StatefulWidget {
  const MapSearchPage({super.key});

  @override
  State<MapSearchPage> createState() => _MapSearchPageState();
}

class _MapSearchPageState extends State<MapSearchPage> {
  final MapController _mapController = MapController();
  final TextEditingController _searchController = TextEditingController();

  final DatabaseReference _database = FirebaseDatabase.instance.ref(
    'live_locations',
  );

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  StreamSubscription<DatabaseEvent>? _locationSubscription;

  LatLng? _currentLocation;
  LatLng? _searchedLocation;

  List<Marker> _liveBusMarkers = [];

  static const LatLng _defaultLocation = LatLng(6.9934, 81.0550);

  static const double _defaultZoom = 13;

  @override
  void initState() {
    super.initState();

    _getCurrentLocation();
    _listenForLiveBuses();
  }

  @override
  void dispose() {
    _searchController.dispose();
    _locationSubscription?.cancel();

    super.dispose();
  }

  Future<void> _getCurrentLocation() async {
    final enabled = await Geolocator.isLocationServiceEnabled();

    if (!enabled) {
      return;
    }

    var permission = await Geolocator.checkPermission();

    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }

    if (permission == LocationPermission.denied ||
        permission == LocationPermission.deniedForever) {
      return;
    }

    try {
      final position = await Geolocator.getCurrentPosition();

      if (!mounted) {
        return;
      }

      final location = LatLng(position.latitude, position.longitude);

      setState(() {
        _currentLocation = location;
      });

      _mapController.move(location, 16);
    } catch (_) {
      return;
    }
  }

  Future<void> _searchLocation(String query) async {
    final trimmedQuery = query.trim();

    if (trimmedQuery.isEmpty) {
      return;
    }

    final url = Uri.https('nominatim.openstreetmap.org', '/search', {
      'q': trimmedQuery,
      'format': 'json',
      'limit': '1',
    });

    try {
      final response = await http.get(
        url,
        headers: const {'User-Agent': 'CeyGo/1.0'},
      );

      if (response.statusCode != 200) {
        return;
      }

      final data = jsonDecode(response.body);

      if (data is! List || data.isEmpty) {
        return;
      }

      final result = data.first;

      final latitude = double.tryParse(result['lat'].toString());

      final longitude = double.tryParse(result['lon'].toString());

      if (latitude == null || longitude == null) {
        return;
      }

      final location = LatLng(latitude, longitude);

      if (!mounted) {
        return;
      }

      setState(() {
        _searchedLocation = location;
      });

      _mapController.move(location, 16);
    } catch (_) {
      return;
    }
  }

  Future<Map<String, dynamic>?> _getRouteData(String? routeId) async {
    if (routeId == null) {
      return null;
    }

    const routeMapping = {'route_001': 'Zl21qkgaUAFZvDkgWCZA'};

    final documentId = routeMapping[routeId];

    if (documentId == null) {
      return null;
    }

    final snapshot = await _firestore
        .collection('routes')
        .doc(documentId)
        .get();

    if (!snapshot.exists) {
      return null;
    }

    return snapshot.data();
  }

  void _listenForLiveBuses() {
    _locationSubscription = _database.onValue.listen((event) {
      final data = event.snapshot.value;

      if (data is! Map) {
        return;
      }

      final markers = <Marker>[];

      data.forEach((busId, value) {
        if (value is! Map) {
          return;
        }

        final bus = Map<dynamic, dynamic>.from(value);

        final latitude = (bus['latitude'] as num?)?.toDouble();
        final longitude = (bus['longitude'] as num?)?.toDouble();

        if (latitude == null || longitude == null) {
          return;
        }

        final heading = (bus['heading'] as num?)?.toDouble() ?? 0;

        markers.add(
          Marker(
            point: LatLng(latitude, longitude),
            width: 70,
            height: 70,
            child: GestureDetector(
              onTap: () async {
                final route = await _getRouteData(bus['routeId']?.toString());

                if (!mounted) {
                  return;
                }

                _showBusInformation(busId.toString(), bus, route);
              },
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 6,
                      vertical: 2,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(6),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.12),
                          blurRadius: 4,
                        ),
                      ],
                    ),
                    child: Text(
                      busId.toString(),
                      style: const TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  const SizedBox(height: 2),
                  Transform.rotate(
                    angle: heading * 3.14159 / 180,
                    child: Image.asset(
                      'assets/images/bus_marker.png',
                      width: 38,
                      height: 38,
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      });

      if (!mounted) {
        return;
      }

      setState(() {
        _liveBusMarkers = markers;
      });
    });
  }

  void _showBusInformation(
    String busId,
    Map<dynamic, dynamic> bus,
    Map<String, dynamic>? route,
  ) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return DraggableScrollableSheet(
          initialChildSize: 0.42,
          minChildSize: 0.28,
          maxChildSize: 0.75,
          builder: (context, scrollController) {
            return Container(
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
              ),
              child: ListView(
                controller: scrollController,
                padding: const EdgeInsets.fromLTRB(20, 12, 20, 30),
                children: [
                  Center(
                    child: Container(
                      width: 42,
                      height: 5,
                      decoration: BoxDecoration(
                        color: Colors.grey.shade300,
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),

                  Row(
                    children: [
                      Container(
                        width: 52,
                        height: 52,
                        padding: const EdgeInsets.all(7),
                        decoration: BoxDecoration(
                          color: AppColors.primary.withValues(alpha: 0.08),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Image.asset('assets/images/bus_marker.png'),
                      ),

                      const SizedBox(width: 14),

                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              busId,
                              style: const TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            Text(
                              route?['routeNumber']?.toString() ??
                                  'Route information unavailable',
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey.shade600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 24),

                  _infoRow(
                    'Route',
                    '${route?['start'] ?? 'Unknown'} → '
                        '${route?['destination'] ?? 'Unknown'}',
                  ),

                  _infoRow('Distance', '${route?['distance'] ?? 0} km'),

                  _infoRow('Speed', '${bus['speed'] ?? 0} km/h'),

                  _infoRow('Direction', '${bus['heading'] ?? 0}°'),

                  const SizedBox(height: 18),

                  const Text(
                    'Stops',
                    style: TextStyle(fontSize: 19, fontWeight: FontWeight.w700),
                  ),

                  const SizedBox(height: 8),

                  if (route?['stops'] is List)
                    ...(route!['stops'] as List).map((stop) {
                      return ListTile(
                        contentPadding: EdgeInsets.zero,
                        leading: const Icon(
                          Icons.location_on_rounded,
                          color: AppColors.primary,
                        ),
                        title: Text(stop['name']?.toString() ?? ''),
                        trailing: Text(
                          stop['eta']?.toString() ?? '',
                          style: const TextStyle(fontWeight: FontWeight.w600),
                        ),
                      );
                    }),

                  const SizedBox(height: 12),

                  _infoRow('Last Update', _formatLastUpdate(bus['updatedAt'])),
                ],
              ),
            );
          },
        );
      },
    );
  }

  String _formatLastUpdate(dynamic timestamp) {
    if (timestamp is! num) {
      return 'Unknown';
    }

    return DateTime.fromMillisecondsSinceEpoch(timestamp.toInt()).toString();
  }

  Widget _infoRow(String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(color: Colors.grey.shade600, fontSize: 15),
          ),
          const SizedBox(width: 20),
          Expanded(
            child: Text(
              value,
              textAlign: TextAlign.right,
              style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          FlutterMap(
            mapController: _mapController,
            options: const MapOptions(
              initialCenter: _defaultLocation,
              initialZoom: _defaultZoom,
            ),
            children: [
              TileLayer(
                urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                userAgentPackageName: 'com.ceygo.transportation',
              ),

              MarkerLayer(
                markers: [
                  if (_currentLocation != null)
                    Marker(
                      point: _currentLocation!,
                      width: 50,
                      height: 50,
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.15),
                              blurRadius: 8,
                            ),
                          ],
                        ),
                        child: const Icon(
                          Icons.my_location_rounded,
                          color: AppColors.primary,
                          size: 28,
                        ),
                      ),
                    ),

                  if (_searchedLocation != null)
                    const Marker(
                      point: _defaultLocation,
                      width: 50,
                      height: 50,
                      child: Icon(
                        Icons.location_pin,
                        color: Colors.red,
                        size: 45,
                      ),
                    ),

                  ..._liveBusMarkers,
                ],
              ),
            ],
          ),

          SafeArea(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 12, 20, 0),
              child: Material(
                color: Colors.transparent,
                elevation: 8,
                shadowColor: Colors.black.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(18),
                child: TextField(
                  controller: _searchController,
                  onSubmitted: _searchLocation,
                  textInputAction: TextInputAction.search,
                  decoration: InputDecoration(
                    hintText: 'Search destination',
                    hintStyle: TextStyle(color: Colors.grey.shade500),
                    prefixIcon: const Icon(
                      Icons.search_rounded,
                      color: AppColors.primary,
                    ),
                    filled: true,
                    fillColor: Colors.white,
                    contentPadding: const EdgeInsets.symmetric(vertical: 16),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(18),
                      borderSide: BorderSide.none,
                    ),
                    suffixIcon: IconButton(
                      onPressed: () {
                        _searchController.clear();
                      },
                      icon: const Icon(Icons.close_rounded, size: 20),
                    ),
                  ),
                ),
              ),
            ),
          ),

          Positioned(
            right: 20,
            bottom: 30,
            child: FloatingActionButton(
              heroTag: 'currentLocationButton',
              backgroundColor: Colors.white,
              foregroundColor: AppColors.primary,
              elevation: 6,
              onPressed: _getCurrentLocation,
              child: const Icon(Icons.my_location_rounded),
            ),
          ),
        ],
      ),
    );
  }
}
