import "package:flutter/material.dart";

import "package:transportation_tracking_system/core/theme/app_colors.dart";

import '../widgets/home_header.dart';
import '../widgets/search_bar.dart';
import '../widgets/bottom_nav_bar.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    final double headerHeight = MediaQuery.of(context).size.height * 0.35;

    return Scaffold(
      backgroundColor: Colors.white,

      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,

            children: [
              // Full width hero section
              Stack(
                children: [
                  Image.asset(
                    "assets/images/home_page_img_background.png",

                    width: double.infinity,

                    height: headerHeight,

                    fit: BoxFit.cover,
                  ),

                  Padding(
                    padding: const EdgeInsets.all(24),

                    child: buildHeader(),
                  ),
                ],
              ),

              // Content below image
              Padding(
                padding: const EdgeInsets.all(24),

                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,

                  children: [
                    buildSearchBar(context),

                    const SizedBox(height: 30),

                    const Text(
                      "Nearby Transport",

                      style: TextStyle(
                        fontSize: 22,

                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),

      bottomNavigationBar: CustomBottomNavBar(
        currentIndex: currentIndex,

        onTap: (index) {
          setState(() {
            currentIndex = index;
          });
        },
      ),
    );
  }
}
