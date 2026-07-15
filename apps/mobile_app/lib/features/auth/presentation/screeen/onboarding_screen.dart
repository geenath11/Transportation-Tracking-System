import 'package:flutter/material.dart';
import '../widgets/onboarding_item.dart';
import 'auth_screen.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen>
    with SingleTickerProviderStateMixin {
  final PageController _pageController = PageController();

  late final AnimationController _pageAnimationController;
  late final Animation<double> _imageScale;
  late final Animation<double> _contentFade;
  late final Animation<Offset> _contentSlide;

  int _currentPage = 0;

  final List<OnboardingItem> _pages = const [
    OnboardingItem(
      primaryIcon: Icons.directions_bus_rounded,
      secondaryIcon: Icons.train_rounded,
      title: 'Track Bus and Train Services',
      description:
      'View available bus and train services, live transport updates and journey information from one place.',
    ),
    OnboardingItem(
      primaryIcon: Icons.route_rounded,
      secondaryIcon: Icons.schedule_rounded,
      title: 'Plan Your Complete Journey',
      description:
      'Find bus routes, train schedules, stations, stops and estimated arrival times easily.',
    ),
    OnboardingItem(
      primaryIcon: Icons.confirmation_number_rounded,
      secondaryIcon: Icons.qr_code_2_rounded,
      title: 'Book and Travel Easily',
      description:
      'Book bus or train tickets, receive a digital QR ticket and manage your upcoming journeys.',
    ),
  ];

  @override
  void initState() {
    super.initState();

    _pageAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 750),
    );

    _imageScale = Tween<double>(
      begin: 0.72,
      end: 1,
    ).animate(
      CurvedAnimation(
        parent: _pageAnimationController,
        curve: Curves.easeOutBack,
      ),
    );

    _contentFade = CurvedAnimation(
      parent: _pageAnimationController,
      curve: Curves.easeIn,
    );

    _contentSlide = Tween<Offset>(
      begin: const Offset(0, 0.25),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _pageAnimationController,
        curve: Curves.easeOutCubic,
      ),
    );

    _pageAnimationController.forward();
  }

  void _animateCurrentPage() {
    _pageAnimationController.reset();
    _pageAnimationController.forward();
  }

  void _openLoginPage() {
    Navigator.pushReplacement(
      context,
      PageRouteBuilder(
        transitionDuration: const Duration(milliseconds: 650),
        pageBuilder: (_, animation, __) {
          return SlideTransition(
            position: Tween<Offset>(
              begin: const Offset(1, 0),
              end: Offset.zero,
            ).animate(
              CurvedAnimation(
                parent: animation,
                curve: Curves.easeOutCubic,
              ),
            ),
            child: const AuthScreen(),
          );
        },
      ),
    );
  }

  void _nextPage() {
    if (_currentPage < _pages.length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 450),
        curve: Curves.easeInOut,
      );
    } else {
      _openLoginPage();
    }
  }

  @override
  void dispose() {
    _pageController.dispose();
    _pageAnimationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Align(
              alignment: Alignment.centerRight,
              child: Padding(
                padding: const EdgeInsets.only(right: 14, top: 4),
                child: TextButton(
                  onPressed: _openLoginPage,
                  child: const Text(
                    'Skip',
                    style: TextStyle(
                      color: Color(0xFF0D5BD7),
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),
            ),
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                itemCount: _pages.length,
                onPageChanged: (index) {
                  setState(() {
                    _currentPage = index;
                  });
                  _animateCurrentPage();
                },
                itemBuilder: (context, index) {
                  final page = _pages[index];

                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 28),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ScaleTransition(
                          scale: _imageScale,
                          child: Container(
                            width: 260,
                            height: 260,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              gradient: const LinearGradient(
                                colors: [
                                  Color(0xFFEAF4FF),
                                  Color(0xFFD4E9FF),
                                ],
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: const Color(0xFF0D5BD7)
                                      .withOpacity(0.13),
                                  blurRadius: 32,
                                  offset: const Offset(0, 16),
                                ),
                              ],
                            ),
                            child: Stack(
                              alignment: Alignment.center,
                              children: [
                                Icon(
                                  page.primaryIcon,
                                  size: 125,
                                  color: const Color(0xFF0D5BD7),
                                ),
                                Positioned(
                                  right: 42,
                                  bottom: 45,
                                  child: Container(
                                    padding: const EdgeInsets.all(13),
                                    decoration: const BoxDecoration(
                                      color: Colors.white,
                                      shape: BoxShape.circle,
                                    ),
                                    child: Icon(
                                      page.secondaryIcon,
                                      size: 42,
                                      color: const Color(0xFF42A5F5),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 48),
                        FadeTransition(
                          opacity: _contentFade,
                          child: SlideTransition(
                            position: _contentSlide,
                            child: Column(
                              children: [
                                Text(
                                  page.title,
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(
                                    fontSize: 27,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFF063A8C),
                                  ),
                                ),
                                const SizedBox(height: 17),
                                Text(
                                  page.description,
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(
                                    fontSize: 16,
                                    height: 1.55,
                                    color: Colors.black54,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                _pages.length,
                    (index) {
                  final selected = index == _currentPage;

                  return AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    margin: const EdgeInsets.symmetric(horizontal: 4),
                    width: selected ? 30 : 9,
                    height: 9,
                    decoration: BoxDecoration(
                      color: selected
                          ? const Color(0xFF0D5BD7)
                          : const Color(0xFFCADDF5),
                      borderRadius: BorderRadius.circular(20),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 28),
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 0, 24, 30),
              child: SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: _currentPage == _pages.length - 1
                      ? _openLoginPage
                      : _nextPage,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF0D5BD7),
                    foregroundColor: Colors.white,
                    elevation: 5,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(17),
                    ),
                  ),
                  child: Text(
                    _currentPage == _pages.length - 1
                        ? 'Get Started'
                        : 'Next',
                    style: const TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

