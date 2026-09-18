import 'package:flutter/material.dart';
import '../core/theme/app_theme.dart';
import '../features/onboarding/splash_screen.dart';

class CeyGoApp extends StatelessWidget {
  const CeyGoApp({super.key});

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
