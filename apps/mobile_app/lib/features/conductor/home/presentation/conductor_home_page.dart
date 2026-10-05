import 'package:flutter/material.dart';
import 'package:transportation_tracking_system/core/services/user_profile_service.dart';
import 'package:transportation_tracking_system/core/widgets/custom_button.dart';
import 'package:transportation_tracking_system/features/conductor/qrscan/presentation/screens/qr_scan_screen.dart';
import 'package:transportation_tracking_system/features/driver/routes/presentation/driver_routes.dart';
import 'package:transportation_tracking_system/features/profile/presentation/screens/profile_screen.dart';

import '../../../../core/theme/app_text_styles.dart';
import '../../pastTrips/presentation/screens/trip_history.dart';
import '../widgets/home_header.dart';
import '../widgets/bottom_nav_bar.dart';

class ConductorHomePage extends StatefulWidget {
  const ConductorHomePage({super.key});

  @override
  State<ConductorHomePage> createState() => _ConductorHomePageState();
}

class _ConductorHomePageState extends State<ConductorHomePage> {
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

    return SafeArea(
      child: SingleChildScrollView(
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
                    'assets/images/conductor_home_page_background.webp',
                    width: double.infinity,
                    height: headerHeight,
                    fit: BoxFit.cover,
                    cacheWidth:
                        MediaQuery.devicePixelRatioOf(context).ceil() *
                        MediaQuery.sizeOf(context).width.toInt(),
                  ),
                ),

                Padding(
                  padding: const EdgeInsets.all(24),
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
                    'Quick Actions',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Poppins',
                      color: Color(0xFF202124),
                    ),
                  ),
                  SizedBox(height: 20),

                  SizedBox(height: 20),

                  Column(
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: AppButton(
                              width: double.infinity,
                              onPressed: () async {
                                final scannedValue =
                                    await Navigator.push<String>(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            const QrScannerScreen(),
                                      ),
                                    );

                                if (scannedValue != null) {
                                  debugPrint('Scanned ticket: $scannedValue');
                                }
                              },
                              child: Text(
                                'Scan QR',
                                style: AppTextStyles.semiBold.copyWith(
                                  fontSize: 18,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: AppButton(
                              width: double.infinity,
                              onPressed: () {
                              },
                              child: Text(
                                'Reserved Seats',
                                style: AppTextStyles.semiBold.copyWith(
                                  fontSize: 18,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          Expanded(
                            child: AppButton(
                              width: double.infinity,
                              onPressed: () {
                              },
                              child: Text(
                                'Seats',
                                style: AppTextStyles.semiBold.copyWith(
                                  fontSize: 18,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: AppButton(
                              width: double.infinity,
                              onPressed: () {
                              },
                              child: Text(
                                'My Trip',
                                style: AppTextStyles.semiBold.copyWith(
                                  fontSize: 18,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
