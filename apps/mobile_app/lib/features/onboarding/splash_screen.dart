import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../core/services/user_profile_service.dart';
import '../../core/theme/app_text_styles.dart';
import '../../firebase_options.dart';
import '../../features/auth/presentation/screen/permission_setup_page.dart';
import '../../features/home/presentation/screen/home_page.dart';
import 'onboarding_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _loadNextScreen();
  }

  Future<void> _loadNextScreen() async {
    await Future.wait([
      Future.delayed(const Duration(seconds: 3)),
      _initializeApp(),
    ]);

    if (!mounted) return;

    User? user;

    try {
      user = FirebaseAuth.instance.currentUser;
    } catch (_) {
      user = null;
    }

    final prefs = await SharedPreferences.getInstance();

    final setupCompleted = prefs.getBool('setup_completed') ?? false;

    if (!mounted) return;

    if (user == null) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const OnboardingScreen()),
      );
      return;
    }

    if (!setupCompleted) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const PermissionSetupPage()),
      );
      return;
    }

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const HomePage()),
    );
  }

  Future<void> _initializeApp() async {
    try {
      await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
      );

      await UserProfileService.instance
          .load()
          .timeout(const Duration(seconds: 4), onTimeout: () {});
    } catch (_) {}
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
