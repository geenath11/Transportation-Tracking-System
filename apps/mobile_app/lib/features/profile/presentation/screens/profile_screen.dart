import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:transportation_tracking_system/core/services/user_profile_service.dart';
import 'package:transportation_tracking_system/features/onboarding/onboarding_screen.dart';
import 'package:transportation_tracking_system/features/profile/presentation/widgets/button_profile.dart';
import 'package:transportation_tracking_system/features/profile/presentation/widgets/profile_header.dart';
import 'package:transportation_tracking_system/features/profile/presentation/widgets/button_signout.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  void _showComingSoon(BuildContext context, String feature) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text('$feature is coming soon'),
        ),
      );
  }

  Future<void> _signOut(BuildContext context) async {
    await FirebaseAuth.instance.signOut();
    await UserProfileService.instance.clear();

    if (!context.mounted) return;

    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(
        builder: (_) => const OnboardingScreen(),
      ),
          (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: UserProfileService.instance,
      builder: (context, _) {
        return Scaffold(
          backgroundColor: Colors.white.withValues(alpha: 0.96),
          body: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const ProfileHeader(),

              const SizedBox(height: 28),

              ButtonProfile(
                text: "Account",
                icon: Icons.account_circle_outlined,
                onPressed: () => _showComingSoon(context, 'Account'),
              ),

              const SizedBox(height: 10),

              ButtonProfile(
                text: "Payment Information",
                icon: Icons.payment_outlined,
                onPressed: () =>
                    _showComingSoon(context, 'Payment Information'),
              ),

              const SizedBox(height: 10),

              ButtonProfile(
                text: "Wallet Balance",
                icon: Icons.account_balance_wallet_outlined,
                onPressed: () => _showComingSoon(context, 'Wallet Balance'),
              ),

              const SizedBox(height: 10),

              ButtonProfile(
                text: "Booking Profile",
                icon: Icons.history_outlined,
                onPressed: () => _showComingSoon(context, 'Booking Profile'),
              ),

              const SizedBox(height: 10),

              ButtonProfile(
                text: "Notification",
                icon: Icons.notifications_none_rounded,
                onPressed: () => _showComingSoon(context, 'Notification'),
              ),

              const Spacer(),

              ButtonProfile(
                text: "Privacy Policy",
                icon: Icons.privacy_tip_outlined,
                onPressed: () => _showComingSoon(context, 'Privacy Policy'),
              ),

              const SizedBox(height: 10),

              ButtonProfile(
                text: "About Us",
                icon: Icons.info_outline_rounded,
                onPressed: () => _showComingSoon(context, 'About Us'),
              ),

              const Spacer(),

              ButtonSignout(
                onPressed: () => _signOut(context),
              ),

              const Spacer(),
            ],
          ),
        );
      },
    );
  }
}