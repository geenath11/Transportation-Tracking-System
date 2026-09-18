import 'package:flutter/material.dart';
import 'package:transportation_tracking_system/core/services/user_profile_service.dart';

import '../widgets/home_header.dart';
import '../widgets/search_bar.dart';
import '../widgets/bottom_nav_bar.dart';
import '../../../profile/presentation/screens/profile_screen.dart';
import '../../../search/presentation/screens/search_screen.dart';
import '../../../tickets/presentation/screens/ticket_screen.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    final headerHeight = MediaQuery.sizeOf(context).height * 0.35;

    Widget page;

    switch (_currentIndex) {
      case 0:
        page = SafeArea(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Stack(
                  children: [
                    Image.asset(
                      'assets/images/home_page_img_background.png',
                      width: double.infinity,
                      height: headerHeight,
                      fit: BoxFit.cover,
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
                      buildSearchBar(context),
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
          ),
        );
        break;
      case 1:
        page = const SearchScreen();
        break;
      case 2:
        page = const TicketScreen();
        break;
      case 3:
        page = const ProfileScreen();
        break;

      default:
        page = Center(
          child: Text(
            'Page $_currentIndex',
            style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
        );
    }

    return Scaffold(
      backgroundColor: Colors.white,
      body: page,
      bottomNavigationBar: CustomBottomNavBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
      ),
    );
  }
}
