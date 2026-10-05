import 'package:flutter/material.dart';
import 'package:transportation_tracking_system/core/services/user_profile_service.dart';
import 'package:transportation_tracking_system/features/driver/routes/presentation/driver_routes.dart';
import 'package:transportation_tracking_system/features/profile/presentation/screens/profile_screen.dart';

import '../../pastTrips/presentation/screens/trip_history.dart';
import '../../../conductor/home/widgets/home_header.dart';
import '../../../conductor/home/widgets/bottom_nav_bar.dart';

class DriverHomePage extends StatefulWidget {
  const DriverHomePage({super.key});

  @override
  State<DriverHomePage> createState() => _DriverHomePageState();
}

class _DriverHomePageState extends State<DriverHomePage> {
  int _currentIndex = 0;

  final List<bool> _tabBuilt = [true, false, false, false];

  void _openTab(int index) {
    setState(() {
      _tabBuilt[index] = true;
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: IndexedStack(
        index: _currentIndex,
        children: [
          _buildHomeTab(context),
          _tabBuilt[1] ? TripHistory() : const SizedBox.shrink(),
          _tabBuilt[2] ? DriverRoutes() : const SizedBox.shrink(),
          _tabBuilt[3] ? ProfileScreen() : const SizedBox.shrink(),
        ],
      ),
      bottomNavigationBar: CustomBottomNavBar(
        currentIndex: _currentIndex,
        onTap: _openTab,
      ),
    );
  }

  Widget _buildHomeTab(BuildContext context) {
    final headerHeight = MediaQuery.sizeOf(context).height * 0.35;

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(30),
                  bottomRight: Radius.circular(30),
                ),
                child: Image.asset(
                  'assets/images/home_page_img_background.jpg',
                  width: double.infinity,
                  height: headerHeight,
                  fit: BoxFit.cover,
                  cacheWidth:
                      MediaQuery.devicePixelRatioOf(context).ceil() *
                      MediaQuery.sizeOf(context).width.toInt(),
                ),
              ),

              Padding(
                padding: EdgeInsets.fromLTRB(
                  24,
                  MediaQuery.paddingOf(context).top + 24,
                  24,
                  24,
                ),
                child: ListenableBuilder(
                  listenable: UserProfileService.instance,
                  builder: (context, _) =>
                      buildHeader(UserProfileService.instance.name),
                ),
              ),
            ],
          ),

          Padding(
            padding: const EdgeInsets.fromLTRB(24, 26, 24, 30),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 28),

                const Text(
                  'Nearby Transport',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Poppins',
                    color: Color(0xFF202124),
                  ),
                ),

                const SizedBox(height: 16),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
