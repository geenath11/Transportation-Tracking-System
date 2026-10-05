import 'package:flutter/material.dart';

import '../../../../core/theme/app_text_styles.dart';

class _PolicyColors {
  static const primary = Color(0xFF3339EC);
  static const primaryDark = Color(0xFF1F24A8);
  static const tintStrong = Color(0xFFDDDFFB);
  static const tintSoft = Color(0xFFF0F1FE);
  static const surface = Color(0xFFF8F9FF);
  static const ink = Color(0xFF14163D);
  static const body = Color(0xFF4A4D6E);
  static const onPrimarySoft = Color(0xCCFFFFFF);
  static const onPrimaryFaint = Color(0x1FFFFFFF);
  static const onPrimaryPill = Color(0x2EFFFFFF);
}


class _PolicySection {
  final int number;
  final String title;
  final String? callout;
  final List<String> paragraphs;
  final List<String> bullets;
  final bool boldLead;

  const _PolicySection({
    required this.number,
    required this.title,
    this.callout,
    this.paragraphs = const [],
    this.bullets = const [],
    this.boldLead = false,
  });
}

const _sections = <_PolicySection>[
  _PolicySection(
    number: 1,
    title: 'Information We Collect',
    paragraphs: [
      'Depending on the features you use, Cey Go may collect:',
    ],
    bullets: [
      'Account Information: Name, email address, phone number, and account '
          'credentials.',
      'Location Information: Your location when you enable location services '
          'for features such as live tracking, route assistance, and nearby '
          'transportation services.',
      'Travel Information: Booking details, ticket information, selected '
          'routes, and travel history.',
      'Device Information: Basic device and technical information required to '
          'provide and improve the application.',
      'Feedback: Information you provide when submitting feedback or '
          'contacting us.',
    ],
    boldLead: true,
  ),
  _PolicySection(
    number: 2,
    title: 'How We Use Your Information',
    paragraphs: ['The collected information may be used to:'],
    bullets: [
      'Create and manage your account.',
      'Provide transportation and route information.',
      'Provide live location and tracking features.',
      'Process bookings and generate QR-based tickets.',
      'Send important notifications and service updates.',
      'Improve application functionality and user experience.',
      'Respond to feedback and support requests.',
      'Maintain the security and reliability of the application.',
    ],
  ),
  _PolicySection(
    number: 3,
    title: 'Location Information',
    paragraphs: [
      'Cey Go may request access to your device location to provide '
          'location-based transportation features.',
      'Location access is used only when required by relevant application '
          'features and according to the permissions you provide. You can '
          'manage location permissions through your device settings.',
    ],
  ),
  _PolicySection(
    number: 4,
    title: 'Sharing of Information',
    callout: 'Cey Go does not sell your personal information.',
    paragraphs: [
      'Information may only be shared when necessary to provide specific '
          'services, operate application features, maintain the system, '
          'comply with legal requirements, or protect the security of users '
          'and the application.',
    ],
  ),
  _PolicySection(
    number: 5,
    title: 'Data Security',
    paragraphs: [
      'We take reasonable measures to protect user information from '
          'unauthorized access, alteration, disclosure, or loss.',
      'However, no electronic system or method of data transmission can be '
          'guaranteed to be completely secure.',
    ],
  ),
  _PolicySection(
    number: 6,
    title: 'Data Retention',
    paragraphs: [
      'We retain information only for as long as it is necessary to provide '
          'the application\'s services, maintain required records, improve '
          'the system, or meet applicable legal requirements.',
    ],
  ),
  _PolicySection(
    number: 7,
    title: 'Third-Party Services',
    paragraphs: [
      'Cey Go may use third-party services and technologies to provide '
          'application functionality, such as authentication, cloud data '
          'storage, notifications, maps, and location services.',
      'These services may process information according to their own '
          'privacy policies.',
    ],
  ),
  _PolicySection(
    number: 8,
    title: 'Your Choices',
    paragraphs: ['You may:'],
    bullets: [
      'Update your account information.',
      'Manage application permissions through your device settings.',
      'Disable location or notification permissions.',
      'Contact us regarding questions about your personal information.',
    ],
  ),
  _PolicySection(
    number: 9,
    title: 'Children\'s Privacy',
    paragraphs: [
      'Cey Go is not specifically designed for children. We do not knowingly '
          'collect personal information from children without appropriate '
          'authorization.',
    ],
  ),
  _PolicySection(
    number: 10,
    title: 'Changes to This Privacy Policy',
    paragraphs: [
      'We may update this Privacy Policy when necessary to reflect changes '
          'to the application, services, or legal requirements.',
      'Any changes will be communicated through the application or by '
          'updating the date shown at the top of this policy.',
    ],
  ),
  _PolicySection(
    number: 11,
    title: 'Contact Us',
    paragraphs: [
      'If you have questions, concerns, or requests regarding this Privacy '
          'Policy, please contact the Cey Go development team through the '
          'contact information provided within the application.',
    ],
  ),
];


class PrivacyPolicyScreen extends StatelessWidget {
  const PrivacyPolicyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _PolicyColors.surface,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        scrolledUnderElevation: 0,
        foregroundColor: Colors.white,
        title: Text(
          'Privacy Policy',
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
              padding: const EdgeInsets.fromLTRB(24, 32, 24, 40),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  for (int i = 0; i < _sections.length; i++) ...[
                    _SectionView(section: _sections[i]),
                    if (i != _sections.length - 1) const _SectionDivider(),
                  ],
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
        color: _PolicyColors.primary,
        child: Stack(
          children: [
            const Positioned(
              right: -28,
              bottom: -30,
              child: Icon(
                Icons.shield_outlined,
                size: 190,
                color: _PolicyColors.onPrimaryFaint,
              ),
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(24, topInset + 20, 24, 36),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Your privacy matters to us.',
                    style: AppTextStyles.bold.copyWith(
                      fontSize: 30,
                      height: 1.2,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 14),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: _PolicyColors.onPrimaryPill,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      'Last updated: October 5, 2026',
                      style: AppTextStyles.regular.copyWith(
                        fontSize: 12.5,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  const SizedBox(height: 18),
                  Text(
                    'Cey Go respects your privacy and is committed to '
                        'protecting the information you provide while using our '
                        'application. This Privacy Policy explains what '
                        'information may be collected, how it is used, and how it '
                        'is protected.',
                    style: AppTextStyles.regular.copyWith(
                      fontSize: 15,
                      height: 1.6,
                      color: _PolicyColors.onPrimarySoft,
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

  Widget _buildClosing() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 26, horizontal: 20),
      decoration: BoxDecoration(
        color: _PolicyColors.primaryDark,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        children: [
          Text(
            'Cey Go – Smart Public Transportation System',
            textAlign: TextAlign.center,
            style: AppTextStyles.semiBold.copyWith(
              fontSize: 15,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            'Making Every Journey Smarter.',
            textAlign: TextAlign.center,
            style: AppTextStyles.regular.copyWith(
              fontSize: 14,
              color: _PolicyColors.onPrimarySoft,
            ),
          ),
        ],
      ),
    );
  }
}


class _SectionDivider extends StatelessWidget {
  const _SectionDivider();

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.symmetric(vertical: 24),
      child: Divider(height: 1, thickness: 1, color: _PolicyColors.tintStrong),
    );
  }
}

class _SectionView extends StatelessWidget {
  final _PolicySection section;
  const _SectionView({required this.section});

  static const double _indent = 48;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              width: 34,
              height: 34,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: _PolicyColors.tintSoft,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(
                '${section.number}',
                style: AppTextStyles.semiBold.copyWith(
                  fontSize: 14,
                  color: _PolicyColors.primary,
                ),
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Text(
                section.title,
                style: AppTextStyles.semiBold.copyWith(
                  fontSize: 18,
                  height: 1.3,
                  color: _PolicyColors.ink,
                ),
              ),
            ),
          ],
        ),
        Padding(
          padding: const EdgeInsets.only(left: _indent, top: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (section.callout != null) ...[
                _Callout(text: section.callout!),
                const SizedBox(height: 12),
              ],
              for (int i = 0; i < section.paragraphs.length; i++) ...[
                _Paragraph(text: section.paragraphs[i]),
                if (i != section.paragraphs.length - 1 ||
                    section.bullets.isNotEmpty)
                  const SizedBox(height: 10),
              ],
              for (final b in section.bullets)
                _Bullet(text: b, boldLead: section.boldLead),
            ],
          ),
        ),
      ],
    );
  }
}

class _Paragraph extends StatelessWidget {
  final String text;
  const _Paragraph({required this.text});

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: AppTextStyles.regular.copyWith(
        fontSize: 14.5,
        height: 1.6,
        color: _PolicyColors.body,
      ),
    );
  }
}

class _Bullet extends StatelessWidget {
  final String text;
  final bool boldLead;
  const _Bullet({required this.text, required this.boldLead});

  @override
  Widget build(BuildContext context) {
    final baseStyle = AppTextStyles.regular.copyWith(
      fontSize: 14.5,
      height: 1.55,
      color: _PolicyColors.body,
    );

    Widget content;
    final split = text.indexOf(':');
    if (boldLead && split != -1) {
      content = Text.rich(
        TextSpan(
          style: baseStyle,
          children: [
            TextSpan(
              text: text.substring(0, split + 1),
              style: AppTextStyles.semiBold.copyWith(
                fontSize: 14.5,
                height: 1.55,
                color: _PolicyColors.ink,
              ),
            ),
            TextSpan(text: text.substring(split + 1)),
          ],
        ),
      );
    } else {
      content = Text(text, style: baseStyle);
    }

    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 8),
            child: Container(
              width: 6,
              height: 6,
              decoration: const BoxDecoration(
                color: _PolicyColors.primary,
                shape: BoxShape.circle,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(child: content),
        ],
      ),
    );
  }
}

class _Callout extends StatelessWidget {
  final String text;
  const _Callout({required this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: _PolicyColors.tintSoft,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        children: [
          const Icon(
            Icons.check_circle_rounded,
            size: 20,
            color: _PolicyColors.primary,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              text,
              style: AppTextStyles.semiBold.copyWith(
                fontSize: 14.5,
                height: 1.4,
                color: _PolicyColors.ink,
              ),
            ),
          ),
        ],
      ),
    );
  }
}