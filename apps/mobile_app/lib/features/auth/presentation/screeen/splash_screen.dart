import 'package:flutter/material.dart';
import 'onboarding_screen.dart';


class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  late final AnimationController _mainController;
  late final AnimationController _vehicleController;

  late final Animation<double> _logoScale;
  late final Animation<double> _logoFade;
  late final Animation<Offset> _titleSlide;
  late final Animation<double> _titleFade;
  late final Animation<Offset> _busSlide;
  late final Animation<Offset> _trainSlide;

  @override
  void initState() {
    super.initState();

    _mainController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1600),
    );

    _vehicleController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1800),
    );

    _logoScale = Tween<double>(
      begin: 0.3,
      end: 1,
    ).animate(
      CurvedAnimation(
        parent: _mainController,
        curve: const Interval(
          0,
          0.65,
          curve: Curves.elasticOut,
        ),
      ),
    );

    _logoFade = CurvedAnimation(
      parent: _mainController,
      curve: const Interval(0, 0.45),
    );

    _titleSlide = Tween<Offset>(
      begin: const Offset(0, 0.6),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _mainController,
        curve: const Interval(
          0.45,
          1,
          curve: Curves.easeOutCubic,
        ),
      ),
    );

    _titleFade = CurvedAnimation(
      parent: _mainController,
      curve: const Interval(0.45, 1),
    );

    _busSlide = Tween<Offset>(
      begin: const Offset(-1.5, 0),
      end: const Offset(0.15, 0),
    ).animate(
      CurvedAnimation(
        parent: _vehicleController,
        curve: Curves.easeInOut,
      ),
    );

    _trainSlide = Tween<Offset>(
      begin: const Offset(1.5, 0),
      end: const Offset(-0.15, 0),
    ).animate(
      CurvedAnimation(
        parent: _vehicleController,
        curve: Curves.easeInOut,
      ),
    );

    _startSplash();
  }

  Future<void> _startSplash() async {
    await _mainController.forward();
    await _vehicleController.forward();

    await Future.delayed(const Duration(milliseconds: 900));

    if (!mounted) return;

    Navigator.pushReplacement(
      context,
      PageRouteBuilder(
        transitionDuration: const Duration(milliseconds: 700),
        pageBuilder: (_, animation, __) {
          return FadeTransition(
            opacity: animation,
            child: const OnboardingScreen(),
          );
        },
      ),
    );
  }

  @override
  void dispose() {
    _mainController.dispose();
    _vehicleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFF063A8C),
              Color(0xFF0D5BD7),
              Color(0xFF4FA8FF),
            ],
          ),
        ),
        child: SafeArea(
          child: Stack(
            children: [
              Positioned(
                top: -80,
                right: -60,
                child: _decorativeCircle(210, 0.10),
              ),
              Positioned(
                bottom: -100,
                left: -80,
                child: _decorativeCircle(250, 0.08),
              ),
              Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    FadeTransition(
                      opacity: _logoFade,
                      child: ScaleTransition(
                        scale: _logoScale,
                        child: Container(
                          width: 145,
                          height: 145,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(38),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.22),
                                blurRadius: 28,
                                offset: const Offset(0, 14),
                              ),
                            ],
                          ),
                          child: const Stack(
                            alignment: Alignment.center,
                            children: [
                              Positioned(
                                left: 22,
                                child: Icon(
                                  Icons.directions_bus_rounded,
                                  size: 62,
                                  color: Color(0xFF0D5BD7),
                                ),
                              ),
                              Positioned(
                                right: 18,
                                top: 34,
                                child: Icon(
                                  Icons.train_rounded,
                                  size: 58,
                                  color: Color(0xFF42A5F5),
                                ),
                              ),
                              Positioned(
                                bottom: 14,
                                child: Icon(
                                  Icons.location_on_rounded,
                                  size: 34,
                                  color: Color(0xFF063A8C),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 28),
                    FadeTransition(
                      opacity: _titleFade,
                      child: SlideTransition(
                        position: _titleSlide,
                        child: const Column(
                          children: [
                            Text(
                              'Cey Go',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 44,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 1.4,
                              ),
                            ),
                            SizedBox(height: 8),
                            Text(
                              'Buses and trains in one journey',
                              style: TextStyle(
                                color: Colors.white70,
                                fontSize: 16,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 55),
                    SizedBox(
                      height: 70,
                      child: Stack(
                        children: [
                          SlideTransition(
                            position: _busSlide,
                            child: const Align(
                              alignment: Alignment.centerLeft,
                              child: Icon(
                                Icons.directions_bus_rounded,
                                size: 64,
                                color: Colors.white,
                              ),
                            ),
                          ),
                          SlideTransition(
                            position: _trainSlide,
                            child: const Align(
                              alignment: Alignment.centerRight,
                              child: Icon(
                                Icons.train_rounded,
                                size: 64,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const Positioned(
                bottom: 42,
                left: 0,
                right: 0,
                child: Column(
                  children: [
                    SizedBox(
                      width: 30,
                      height: 30,
                      child: CircularProgressIndicator(
                        color: Colors.white,
                        strokeWidth: 3,
                      ),
                    ),
                    SizedBox(height: 14),
                    Text(
                      'Preparing your journey...',
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _decorativeCircle(double size, double opacity) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.white.withOpacity(opacity),
      ),
    );
  }
}
