import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:transportation_tracking_system/core/services/user_profile_service.dart';
import 'package:transportation_tracking_system/core/theme/app_colors.dart';
import 'package:transportation_tracking_system/core/theme/app_text_styles.dart';

import '../../../../profile/presentation/screens/profile_screen.dart';

import '../widgets/home_header.dart';
import '../widgets/search_bar.dart';
import '../widgets/bottom_nav_bar.dart';

import '../../../search/presentation/screens/search_screen.dart';
import '../../../ticket/presentation/screens/my_tickets_screen.dart';

import '../data/services/favorite_route_service.dart';

class PassengerHomePage extends StatefulWidget {
  const PassengerHomePage({super.key});

  @override
  State<PassengerHomePage> createState() => _PassengerHomePageState();
}

class _PassengerHomePageState extends State<PassengerHomePage> {
  int _currentIndex = 0;

  final List<bool> _tabBuilt = [true, false, false, false];

  List<DocumentSnapshot<Map<String, dynamic>>> _favoriteRoutes = [];

  bool _isLoadingFavorites = true;

  @override
  void initState() {
    super.initState();
    _loadFavoriteRoutes();
  }

  void _openTab(int index) {
    if (_tabBuilt[index]) {
      setState(() => _currentIndex = index);
      return;
    }

    setState(() {
      _tabBuilt[index] = true;
      _currentIndex = index;
    });
  }

  Future<void> _loadFavoriteRoutes() async {
    try {
      final routes = await FavoriteRouteService.getFavoriteRoutes();

      if (!mounted) return;

      setState(() {
        _favoriteRoutes = routes;
        _isLoadingFavorites = false;
      });
    } catch (e) {
      if (!mounted) return;

      setState(() {
        _isLoadingFavorites = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: IndexedStack(
        index: _currentIndex,
        children: [
          _buildHomeTab(context),
          _tabBuilt[1] ? const SearchScreen() : const SizedBox.shrink(),
          _tabBuilt[2] ? const MyTicketsScreen() : const SizedBox.shrink(),
          _tabBuilt[3] ? const ProfileScreen() : const SizedBox.shrink(),
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
                  padding: const EdgeInsets.all(24),
                  child: ListenableBuilder(
                    listenable: UserProfileService.instance,
                    builder: (context, _) =>
                        buildHeader(context, UserProfileService.instance.name),
                  ),
                ),
              ],
            ),

            Padding(
              padding: const EdgeInsets.fromLTRB(24, 26, 24, 30),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  buildSearchBar(context),

                  const SizedBox(height: 28),

                  _buildFavoriteRoutes(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFavoriteRoutes() {
    if (_isLoadingFavorites) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 20),
          child: CircularProgressIndicator(),
        ),
      );
    }

    if (_favoriteRoutes.isEmpty) {
      return Container(
        width: double.infinity,
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.grey.shade100,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          children: [
            Icon(Icons.favorite_border, size: 32, color: Colors.grey.shade600),

            const SizedBox(height: 8),

            Text(
              'No favorite routes yet',
              style: AppTextStyles.semiBold.copyWith(
                fontSize: 16,
                color: Colors.black87,
              ),
            ),

            const SizedBox(height: 4),

            Text(
              'Save a route to see it here.',
              textAlign: TextAlign.center,
              style: AppTextStyles.regular.copyWith(
                fontSize: 13,
                color: Colors.grey.shade600,
              ),
            ),
          ],
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Favorite Routes',
          style: AppTextStyles.bold.copyWith(
            fontSize: 22,
            color: const Color(0xFF202124),
          ),
        ),

        const SizedBox(height: 16),

        ..._favoriteRoutes.map((route) {
          final data = route.data()!;

          final departureCity = data['departureCity']?.toString() ?? '';

          final arrivalCity = data['arrivalCity']?.toString() ?? '';

          final departureTime = data['departureTime']?.toString() ?? '';

          final arrivalTime = data['arrivalTime']?.toString() ?? '';

          return Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: _buildFavoriteRouteCard(
              departureCity: departureCity,
              arrivalCity: arrivalCity,
              departureTime: departureTime,
              arrivalTime: arrivalTime,
            ),
          );
        }),
      ],
    );
  }

  Widget _buildFavoriteRouteCard({
    required String departureCity,
    required String arrivalCity,
    required String departureTime,
    required String arrivalTime,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.black12),
      ),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.favorite,
              color: AppColors.primary,
              size: 22,
            ),
          ),

          const SizedBox(width: 14),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '$departureCity → $arrivalCity',
                  style: AppTextStyles.semiBold.copyWith(
                    fontSize: 16,
                    color: Colors.black,
                  ),
                ),

                const SizedBox(height: 5),

                Text(
                  '$departureTime → $arrivalTime',
                  style: AppTextStyles.regular.copyWith(
                    fontSize: 13,
                    color: Colors.black54,
                  ),
                ),
              ],
            ),
          ),

          const Icon(Icons.chevron_right, color: Colors.black45),
        ],
      ),
    );
  }
}
