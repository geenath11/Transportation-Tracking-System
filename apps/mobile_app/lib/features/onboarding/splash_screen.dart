import 'package:flutter/material.dart';
import 'onboarding_screen.dart';
import '../../core/theme/app_text_styles.dart ';

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
    // Wait time for splash screen
    await Future.delayed(const Duration(seconds: 3));

    if (!mounted) return;

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const OnboardingScreen()),
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
              "Cey Go",
              style: AppTextStyles.bold.copyWith(
                fontSize: 65,
                color: Colors.white,
              ),
            ),
            SizedBox(height: 5),
            Text(
              "Smart Travel Starts Here",
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
