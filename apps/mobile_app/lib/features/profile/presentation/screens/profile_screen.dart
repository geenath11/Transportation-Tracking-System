import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:transportation_tracking_system/core/services/user_profile_service.dart';
import 'package:transportation_tracking_system/features/profile/presentation/screens/privacy_policy_screen.dart';
import '../../../auth/onboarding/onboarding_screen.dart';
import '../widgets/button_profile.dart';
import '../widgets/button_signout.dart';
import '../widgets/profile_header.dart';
import 'about_us_screen.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  void _showComingSoon(BuildContext context, String feature) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text('$feature is coming soon')));
  }

  Future<void> _signOut(BuildContext context) async {
    await FirebaseAuth.instance.signOut();
    await UserProfileService.instance.clear();

    if (!context.mounted) return;

    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (_) => const OnboardingScreen()),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: UserProfileService.instance,
      builder: (context, _) {
        final screenWidth = MediaQuery.sizeOf(context).width;

        const referenceWidth = 360.0;

        final scale = screenWidth / referenceWidth;

        final spacingScale = scale.clamp(0.90, 1.10);

        return Scaffold(
          backgroundColor: Colors.white.withValues(alpha: 0.96),
          body: SafeArea(
            child: Column(
              children: [
                const ProfileHeader(),

                Expanded(
                  child: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    padding: EdgeInsets.only(
                      top: 28 * spacingScale,
                      bottom: 24 * spacingScale,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        ButtonProfile(
                          text: "Account",
                          icon: Icons.account_circle_outlined,
                          onPressed: () => _showComingSoon(context, 'Account'),
                        ),

                        SizedBox(height: 10 * spacingScale),

                        ButtonProfile(
                          text: "Payment Information",
                          icon: Icons.payment_outlined,
                          onPressed: () =>
                              _showComingSoon(context, 'Payment Information'),
                        ),

                        SizedBox(height: 10 * spacingScale),

                        ButtonProfile(
                          text: "Wallet Balance",
                          icon: Icons.account_balance_wallet_outlined,
                          onPressed: () =>
                              _showComingSoon(context, 'Wallet Balance'),
                        ),

                        SizedBox(height: 10 * spacingScale),

                        ButtonProfile(
                          text: "Booking Profile",
                          icon: Icons.history_outlined,
                          onPressed: () =>
                              _showComingSoon(context, 'Booking Profile'),
                        ),

                        SizedBox(height: 10 * spacingScale),

                        ButtonProfile(
                          text: "Notification",
                          icon: Icons.notifications_none_rounded,
                          onPressed: () =>
                              _showComingSoon(context, 'Notification'),
                        ),

                        SizedBox(height: 28 * spacingScale),

                        ButtonProfile(
                          text: "Privacy Policy",
                          icon: Icons.privacy_tip_outlined,
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => const PrivacyPolicyScreen(),
                              ),
                            );

                          },
                        ),

                        SizedBox(height: 10 * spacingScale),

                        ButtonProfile(
                          text: 'About Us',
                          icon: Icons.info_outline_rounded,
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => const AboutUsScreen(),
                              ),
                            );
                          },
                        ),

                        SizedBox(height: 28 * spacingScale),

                        ButtonSignout(onPressed: () => _signOut(context)),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
