import 'package:flutter/material.dart';

void main() {
  runApp(const CeyGoApp());
}

class CeyGoApp extends StatelessWidget {
  const CeyGoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Cey Go',
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF0D5BD7),
        ),
        scaffoldBackgroundColor: Colors.white,
      ),
      home: const SplashScreen(),
    );
  }
}

// -----------------------------------------------------------------------------
// SPLASH SCREEN
// -----------------------------------------------------------------------------

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

// -----------------------------------------------------------------------------
// ONBOARDING MODEL
// -----------------------------------------------------------------------------

class OnboardingItem {
  final IconData primaryIcon;
  final IconData secondaryIcon;
  final String title;
  final String description;

  const OnboardingItem({
    required this.primaryIcon,
    required this.secondaryIcon,
    required this.title,
    required this.description,
  });
}

// -----------------------------------------------------------------------------
// ONBOARDING / SWIPE SCREENS
// -----------------------------------------------------------------------------

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

// -----------------------------------------------------------------------------
// SIGN-IN / SIGN-UP SCREEN
// -----------------------------------------------------------------------------

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _logoScale;
  late final Animation<double> _formFade;
  late final Animation<Offset> _formSlide;

  bool _isSignIn = true;
  bool _hidePassword = true;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1100),
    );

    _logoScale = Tween<double>(
      begin: 0.4,
      end: 1,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(
          0,
          0.65,
          curve: Curves.elasticOut,
        ),
      ),
    );

    _formFade = CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.35, 1),
    );

    _formSlide = Tween<Offset>(
      begin: const Offset(0, 0.25),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(
          0.35,
          1,
          curve: Curves.easeOutCubic,
        ),
      ),
    );

    _controller.forward();
  }

  void _switchMode(bool signIn) {
    if (_isSignIn == signIn) return;

    setState(() {
      _isSignIn = signIn;
    });

    _controller.reset();
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  InputDecoration _inputDecoration({
    required String label,
    required IconData icon,
    Widget? suffix,
  }) {
    return InputDecoration(
      labelText: label,
      prefixIcon: Icon(icon),
      suffixIcon: suffix,
      filled: true,
      fillColor: const Color(0xFFF7FAFE),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: const BorderSide(
          color: Color(0xFFD7E5F6),
        ),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: const BorderSide(
          color: Color(0xFFD7E5F6),
        ),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: const BorderSide(
          color: Color(0xFF0D5BD7),
          width: 1.7,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(24, 28, 24, 32),
          child: Column(
            children: [
              ScaleTransition(
                scale: _logoScale,
                child: Container(
                  width: 105,
                  height: 105,
                  decoration: BoxDecoration(
                    color: const Color(0xFFE8F3FF),
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: const Stack(
                    alignment: Alignment.center,
                    children: [
                      Positioned(
                        left: 16,
                        child: Icon(
                          Icons.directions_bus_rounded,
                          size: 49,
                          color: Color(0xFF0D5BD7),
                        ),
                      ),
                      Positioned(
                        right: 13,
                        top: 26,
                        child: Icon(
                          Icons.train_rounded,
                          size: 43,
                          color: Color(0xFF42A5F5),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                'Welcome to Cey Go',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF063A8C),
                ),
              ),
              const SizedBox(height: 7),
              Text(
                _isSignIn
                    ? 'Sign in to continue your journey'
                    : 'Create your Cey Go account',
                style: const TextStyle(
                  fontSize: 15,
                  color: Colors.black54,
                ),
              ),
              const SizedBox(height: 28),
              Container(
                padding: const EdgeInsets.all(5),
                decoration: BoxDecoration(
                  color: const Color(0xFFEAF2FC),
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: _modeButton(
                        title: 'Sign In',
                        selected: _isSignIn,
                        onTap: () => _switchMode(true),
                      ),
                    ),
                    Expanded(
                      child: _modeButton(
                        title: 'Sign Up',
                        selected: !_isSignIn,
                        onTap: () => _switchMode(false),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 28),
              FadeTransition(
                opacity: _formFade,
                child: SlideTransition(
                  position: _formSlide,
                  child: AnimatedSwitcher(
                    duration: const Duration(milliseconds: 350),
                    child: Column(
                      key: ValueKey(_isSignIn),
                      children: [
                        if (!_isSignIn) ...[
                          TextField(
                            decoration: _inputDecoration(
                              label: 'Full name',
                              icon: Icons.person_outline_rounded,
                            ),
                          ),
                          const SizedBox(height: 16),
                        ],
                        TextField(
                          keyboardType: TextInputType.emailAddress,
                          decoration: _inputDecoration(
                            label: 'Email address',
                            icon: Icons.email_outlined,
                          ),
                        ),
                        const SizedBox(height: 16),
                        TextField(
                          obscureText: _hidePassword,
                          decoration: _inputDecoration(
                            label: 'Password',
                            icon: Icons.lock_outline_rounded,
                            suffix: IconButton(
                              onPressed: () {
                                setState(() {
                                  _hidePassword = !_hidePassword;
                                });
                              },
                              icon: Icon(
                                _hidePassword
                                    ? Icons.visibility_off_outlined
                                    : Icons.visibility_outlined,
                              ),
                            ),
                          ),
                        ),
                        if (!_isSignIn) ...[
                          const SizedBox(height: 16),
                          TextField(
                            obscureText: true,
                            decoration: _inputDecoration(
                              label: 'Confirm password',
                              icon: Icons.lock_reset_rounded,
                            ),
                          ),
                        ],
                        if (_isSignIn)
                          Align(
                            alignment: Alignment.centerRight,
                            child: TextButton(
                              onPressed: () {},
                              child: const Text('Forgot password?'),
                            ),
                          )
                        else
                          const SizedBox(height: 22),
                        SizedBox(
                          width: double.infinity,
                          height: 56,
                          child: ElevatedButton(
                            onPressed: () {},
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF0D5BD7),
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
                              ),
                            ),
                            child: Text(
                              _isSignIn ? 'Sign In' : 'Create Account',
                              style: const TextStyle(
                                fontSize: 17,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 22),
                        Row(
                          children: [
                            const Expanded(child: Divider()),
                            Padding(
                              padding:
                              const EdgeInsets.symmetric(horizontal: 12),
                              child: Text(
                                'OR',
                                style: TextStyle(
                                  color: Colors.grey.shade600,
                                ),
                              ),
                            ),
                            const Expanded(child: Divider()),
                          ],
                        ),
                        const SizedBox(height: 22),
                        SizedBox(
                          width: double.infinity,
                          height: 54,
                          child: OutlinedButton.icon(
                            onPressed: () {},
                            icon: const Icon(Icons.g_mobiledata_rounded),
                            label: const Text(
                              'Continue with Google',
                              style: TextStyle(
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            style: OutlinedButton.styleFrom(
                              foregroundColor: const Color(0xFF0D5BD7),
                              side: const BorderSide(
                                color: Color(0xFF0D5BD7),
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _modeButton({
    required String title,
    required bool selected,
    required VoidCallback onTap,
  }) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 250),
      decoration: BoxDecoration(
        color: selected ? Colors.white : Colors.transparent,
        borderRadius: BorderRadius.circular(12),
        boxShadow: selected
            ? [
          BoxShadow(
            color: Colors.black.withOpacity(0.07),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ]
            : null,
      ),
      child: TextButton(
        onPressed: onTap,
        child: Text(
          title,
          style: TextStyle(
            color: selected
                ? const Color(0xFF0D5BD7)
                : Colors.black54,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}