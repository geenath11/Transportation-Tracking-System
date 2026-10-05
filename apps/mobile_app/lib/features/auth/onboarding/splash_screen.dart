import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../core/routing/role_router.dart';
import '../../../core/services/user_profile_service.dart';
import '../../../core/theme/app_text_styles.dart';

import '../auth/presentation/screen/permission_setup_page.dart';
import 'onboarding_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  static const Duration _minimumSplashDuration = Duration(milliseconds: 800);

  static const Duration _remoteProfileTimeout = Duration(seconds: 4);

  @override
  void initState() {
    super.initState();
    _loadNextScreen();
  }

  Future<void> _loadNextScreen() async {
    await Future.wait([
      Future.delayed(_minimumSplashDuration),
      _loadCachedProfile(),
    ]);

    if (!mounted) return;

    User? user;

    try {
      user = FirebaseAuth.instance.currentUser;
    } catch (e) {
      debugPrint('Failed to get Firebase user: $e');
      user = null;
    }

    final prefs = await SharedPreferences.getInstance();

    final setupCompleted = prefs.getBool('setup_completed') ?? false;

    final roleIsCached = prefs.containsKey(UserProfileService.roleCacheKey);

    if (!mounted) return;

    if (user == null) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const OnboardingScreen()),
      );
      return;
    }

    if (!setupCompleted) {
      unawaited(_refreshProfile());

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const PermissionSetupPage()),
      );
      return;
    }


    if (roleIsCached) {
      unawaited(_refreshProfile());
    } else {
      await _refreshProfile();

      if (!mounted) return;
    }

    final role = UserProfileService.instance.role;

    debugPrint('Logged-in user: ${user.uid}');
    debugPrint('User role: $role');

    final homePage = RoleRouter.getHomeForRole(role);

    if (homePage == null) {
      debugPrint('WARNING: Unknown or missing user role: $role');

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const OnboardingScreen()),
      );

      return;
    }

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => homePage),
    );
  }

  Future<void> _loadCachedProfile() async {
    try {
      await UserProfileService.instance.loadFromCache();
    } catch (e, stackTrace) {
      debugPrint('Failed to load cached profile: $e');

      debugPrintStack(stackTrace: stackTrace);
    }
  }

  Future<void> _refreshProfile() {
    return UserProfileService.instance.load().timeout(
      _remoteProfileTimeout,
      onTimeout: () {
        debugPrint('User profile loading timed out.');
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF3339EC), Color(0xFF4CA0F3)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Cey Go',
              style: AppTextStyles.bold.copyWith(
                fontSize: 65,
                color: Colors.white,
              ),
            ),

            const SizedBox(height: 5),

            Text(
              'Smart Travel Starts Here',
              style: AppTextStyles.semiBold.copyWith(
                fontSize: 20,
                color: Colors.white.withValues(alpha: 0.6),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
