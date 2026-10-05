import 'package:flutter/material.dart';

import '../../../../core/theme/app_text_styles.dart';

class _AboutColors {
  static const primary = Color(0xFF3339EC);
  static const primaryDark = Color(0xFF1F24A8);
  static const tintStrong = Color(0xFFDDDFFB);
  static const tintSoft = Color(0xFFF0F1FE);
  static const surface = Color(0xFFF8F9FF);
  static const ink = Color(0xFF14163D);
  static const body = Color(0xFF4A4D6E);
  static const onPrimarySoft = Color(0xCCFFFFFF);
  static const routeLine = Color(0x40FFFFFF);
}

class AboutUsScreen extends StatelessWidget {
  const AboutUsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _AboutColors.surface,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        scrolledUnderElevation: 0,
        foregroundColor: Colors.white,
        title: Text(
          'About Cey Go',
          style: AppTextStyles.semiBold.copyWith(
            fontSize: 18,
            color: Colors.white,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHero(context),
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 28, 24, 40),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildBody(
                    'Our application brings public transportation services '
                    'together in one platform, helping passengers find bus '
                    'and train information, view routes and schedules, track '
                    'vehicles, estimate arrival times, and manage their '
                    'journeys more efficiently.',
                  ),
                  const SizedBox(height: 32),
                  _buildStatement(
                    title: 'Our Mission',
                    text:
                        'Our mission is to improve the public transportation '
                        'experience by providing passengers with reliable and '
                        'accessible transportation information through modern '
                        'technology.',
                  ),
                  const SizedBox(height: 22),
                  _buildStatement(
                    title: 'Our Vision',
                    text:
                        'We aim to create a more connected and '
                        'technology-driven public transportation experience '
                        'where passengers can travel with greater confidence, '
                        'convenience, and awareness.',
                  ),
                  const SizedBox(height: 36),
                  _buildSectionTitle('What Cey Go Provides'),
                  const SizedBox(height: 16),
                  _buildFeatureGrid(),
                  const SizedBox(height: 36),
                  _buildSectionTitle('For Drivers and Conductors'),
                  const SizedBox(height: 8),
                  _buildBody(
                    'Cey Go also provides dedicated features for '
                    'transportation staff.',
                  ),
                  const SizedBox(height: 16),
                  _buildStaffPanel(),
                  const SizedBox(height: 36),
                  _buildClosing(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }


  Widget _buildHero(BuildContext context) {
    final topInset = MediaQuery.of(context).padding.top + kToolbarHeight;

    return ClipRRect(
      borderRadius: const BorderRadius.vertical(bottom: Radius.circular(32)),
      child: Container(
        width: double.infinity,
        color: _AboutColors.primary,
        child: Stack(
          children: [
            Positioned.fill(child: CustomPaint(painter: _RoutePainter())),
            Padding(
              padding: EdgeInsets.fromLTRB(24, topInset + 20, 24, 40),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Making every journey smarter.',
                    style: AppTextStyles.bold.copyWith(
                      fontSize: 30,
                      height: 1.2,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Cey Go is a smart public transportation platform '
                    'designed to make travelling easier, safer, and more '
                    'convenient for passengers in the Badulla District.',
                    style: AppTextStyles.regular.copyWith(
                      fontSize: 15,
                      height: 1.6,
                      color: _AboutColors.onPrimarySoft,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }


  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: AppTextStyles.semiBold.copyWith(
        fontSize: 20,
        color: _AboutColors.ink,
      ),
    );
  }

  Widget _buildBody(String text) {
    return Text(
      text,
      style: AppTextStyles.regular.copyWith(
        fontSize: 15,
        height: 1.6,
        color: _AboutColors.body,
      ),
    );
  }

  Widget _buildStatement({required String title, required String text}) {
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            width: 4,
            decoration: BoxDecoration(
              color: _AboutColors.primary,
              borderRadius: BorderRadius.circular(4),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildSectionTitle(title),
                const SizedBox(height: 8),
                _buildBody(text),
              ],
            ),
          ),
        ],
      ),
    );
  }


  static const _features = <_Feature>[
    _Feature(Icons.directions_bus_rounded, 'Bus and train service information'),
    _Feature(Icons.my_location_rounded, 'Live vehicle location and tracking'),
    _Feature(Icons.alt_route_rounded, 'Route and destination information'),
    _Feature(Icons.schedule_rounded, 'Estimated arrival information'),
    _Feature(Icons.qr_code_2_rounded, 'Online booking and QR-based tickets'),
    _Feature(
      Icons.notifications_none_rounded,
      'Travel and service notifications',
    ),
    _Feature(
      Icons.person_outline_rounded,
      'Passenger profiles and travel history',
    ),
    _Feature(Icons.support_agent_rounded, 'Passenger feedback and support'),
  ];

  Widget _buildFeatureGrid() {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: _features.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 12,
        crossAxisSpacing: 12,
        mainAxisExtent: 112,
      ),
      itemBuilder: (context, index) => _FeatureTile(feature: _features[index]),
    );
  }


  Widget _buildStaffPanel() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: _AboutColors.tintSoft,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        children: const [
          _StaffRow(
            icon: Icons.route_rounded,
            role: 'Drivers',
            text: 'Access assigned routes and schedules.',
          ),
          SizedBox(height: 18),
          _StaffRow(
            icon: Icons.verified_outlined,
            role: 'Conductors',
            text:
                'Manage bookings, verify QR tickets, and confirm '
                'passenger boarding.',
          ),
        ],
      ),
    );
  }


  Widget _buildClosing() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 26, horizontal: 20),
      decoration: BoxDecoration(
        color: _AboutColors.primaryDark,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Text(
        'Cey Go – Making Every Journey Smarter.',
        textAlign: TextAlign.center,
        style: AppTextStyles.semiBold.copyWith(
          fontSize: 16,
          color: Colors.white,
        ),
      ),
    );
  }
}


class _Feature {
  final IconData icon;
  final String label;
  const _Feature(this.icon, this.label);
}

class _FeatureTile extends StatelessWidget {
  final _Feature feature;
  const _FeatureTile({required this.feature});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: _AboutColors.tintStrong),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: const BoxDecoration(
              color: _AboutColors.tintSoft,
              shape: BoxShape.circle,
            ),
            child: Icon(feature.icon, size: 20, color: _AboutColors.primary),
          ),
          const Spacer(),
          Text(
            feature.label,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: AppTextStyles.regular.copyWith(
              fontSize: 13.5,
              height: 1.3,
              color: _AboutColors.ink,
            ),
          ),
        ],
      ),
    );
  }
}

class _StaffRow extends StatelessWidget {
  final IconData icon;
  final String role;
  final String text;

  const _StaffRow({required this.icon, required this.role, required this.text});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: _AboutColors.primary,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(icon, size: 22, color: Colors.white),
        ),
        const SizedBox(width: 14),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                role,
                style: AppTextStyles.semiBold.copyWith(
                  fontSize: 15,
                  color: _AboutColors.ink,
                ),
              ),
              const SizedBox(height: 3),
              Text(
                text,
                style: AppTextStyles.regular.copyWith(
                  fontSize: 14,
                  height: 1.5,
                  color: _AboutColors.body,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _RoutePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;

    final path = Path()
      ..moveTo(w * 0.52, h * 0.98)
      ..cubicTo(w * 0.70, h * 0.80, w * 0.62, h * 0.52, w * 0.82, h * 0.40)
      ..cubicTo(w * 0.95, h * 0.32, w * 0.92, h * 0.16, w * 1.02, h * 0.10);

    final line = Paint()
      ..color = _AboutColors.routeLine
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3
      ..strokeCap = StrokeCap.round;
    canvas.drawPath(path, line);

    final stopFill = Paint()..color = _AboutColors.primary;
    final stopRing = Paint()
      ..color = _AboutColors.routeLine
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3;

    for (final metric in path.computeMetrics()) {
      for (final fraction in [0.35, 0.70]) {
        final tangent = metric.getTangentForOffset(metric.length * fraction);
        if (tangent == null) continue;
        canvas.drawCircle(tangent.position, 7, stopFill);
        canvas.drawCircle(tangent.position, 7, stopRing);
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
