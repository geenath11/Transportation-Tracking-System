import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;

import '../../../../../core/theme/app_colors.dart';

class MapSearchPage extends StatefulWidget {
  const MapSearchPage({super.key});

  @override
  State<MapSearchPage> createState() => _MapSearchPageState();
}

class _MapSearchPageState extends State<MapSearchPage> {
  final MapController mapController = MapController();

  final TextEditingController searchController = TextEditingController();

  LatLng? currentLocation;
  LatLng? searchedLocation;

  @override
  void initState() {
    super.initState();
    getCurrentLocation();
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  Future<void> getCurrentLocation() async {
    bool enabled = await Geolocator.isLocationServiceEnabled();

    if (!enabled) {
      return;
    }

    LocationPermission permission = await Geolocator.checkPermission();

    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }

    if (permission == LocationPermission.denied ||
        permission == LocationPermission.deniedForever) {
      return;
    }

    Position position = await Geolocator.getCurrentPosition();

    setState(() {
      currentLocation = LatLng(position.latitude, position.longitude);
    });

    mapController.move(currentLocation!, 16);
  }

  Future<void> searchLocation(String query) async {
    if (query.trim().isEmpty) return;

    final url = Uri.parse(
      "https://nominatim.openstreetmap.org/search?q=$query&format=json&limit=1",
    );

    final response = await http.get(url, headers: {"User-Agent": "CeyGo/1.0"});

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);

      if (data.isNotEmpty) {
        final lat = double.parse(data[0]["lat"]);
        final lon = double.parse(data[0]["lon"]);

        setState(() {
          searchedLocation = LatLng(lat, lon);
        });

        mapController.move(searchedLocation!, 16);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          FlutterMap(
            mapController: mapController,
            options: MapOptions(
              initialCenter: const LatLng(6.9934, 81.0550),
              initialZoom: 13,
            ),
            children: [
              TileLayer(
                urlTemplate: "https://tile.openstreetmap.org/{z}/{x}/{y}.png",
                userAgentPackageName: "com.ceygo.transportation",
              ),

              MarkerLayer(
                markers:
                    [
                      if (currentLocation != null)
                        Marker(
                          point: currentLocation!,
                          width: 50,
                          height: 50,
                          child: const Icon(
                            Icons.pin_drop,
                            color: AppColors.primary,
                            size: 35,
                          ),
                        ),

                      if (searchedLocation != null)
                        const Marker(
                          point: LatLng(0, 0), // replaced below
                          width: 50,
                          height: 50,
                          child: SizedBox(),
                        ),
                    ].map((marker) {
                      if (marker.point.latitude == 0 &&
                          marker.point.longitude == 0 &&
                          searchedLocation != null) {
                        return Marker(
                          point: searchedLocation!,
                          width: 50,
                          height: 50,
                          child: const Icon(
                            Icons.location_pin,
                            color: Colors.red,
                            size: 45,
                          ),
                        );
                      }
                      return marker;
                    }).toList(),
              ),
            ],
          ),

          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: TextField(
                controller: searchController,
                onSubmitted: searchLocation,
                decoration: InputDecoration(
                  hintText: "Search destination",

                  prefixIcon: IconButton(
                    icon: const Icon(Icons.search, color: AppColors.primary),
                    onPressed: () {
                      searchLocation(searchController.text);
                    },
                  ),

                  filled: true,
                  fillColor: Colors.white,

                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                    borderSide: BorderSide.none,
                  ),

                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                    borderSide: const BorderSide(
                      color: AppColors.primary,
                      width: 2,
                    ),
                  ),
                ),
              ),
            ),
          ),

          Positioned(
            bottom: 30,
            right: 20,
            child: FloatingActionButton(
              backgroundColor: AppColors.primary,
              onPressed: getCurrentLocation,
              child: const Icon(Icons.my_location, color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }
}
