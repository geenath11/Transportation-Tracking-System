import 'package:flutter/material.dart';
import '../core/theme/app_theme.dart';
import '../core/services/app_preferences.dart';
import '../features/auth/onboarding/splash_screen.dart';

class CeyGoApp extends StatelessWidget {
  final AppPreferences appPreferences;

  const CeyGoApp({super.key, required this.appPreferences});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Cey Go',
      theme: AppTheme.light,
      home: const SplashScreen(),
    );
  }
}
