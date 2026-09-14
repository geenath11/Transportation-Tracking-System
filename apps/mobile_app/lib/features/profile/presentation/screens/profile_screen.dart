import 'package:flutter/material.dart';
import 'package:transportation_tracking_system/features/profile/presentation/widgets/button_profile.dart';
import 'package:transportation_tracking_system/features/profile/presentation/widgets/profile_header.dart';
import 'package:transportation_tracking_system/features/profile/presentation/widgets/button_signout.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white.withValues(alpha: 0.96),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const ProfileHeader(),

          const SizedBox(height: 28),

          ButtonProfile(
            text: "Account",
            icon: Icons.account_circle_rounded,
            onPressed: () {},
          ),

          const SizedBox(height: 10),

          ButtonProfile(
            text: "Payment Information",
            icon: Icons.payment_rounded,
            onPressed: () {},
          ),

          const SizedBox(height: 10),

          ButtonProfile(
            text: "Wallet Balance",
            icon: Icons.account_balance_wallet_rounded,
            onPressed: () {},
          ),

          const SizedBox(height: 10),

          ButtonProfile(
            text: "Booking Profile",
            icon: Icons.history_rounded,
            onPressed: () {},
          ),

          const SizedBox(height: 10),

          ButtonProfile(
            text: "Notification",
            icon: Icons.notifications_rounded,
            onPressed: () {},
          ),

          const Spacer(),

          ButtonProfile(
            text: "Privacy Policy",
            icon: Icons.privacy_tip_rounded,
            onPressed: () {},
          ),

          const SizedBox(height: 10),

          ButtonProfile(
            text: "About Us",
            icon: Icons.info_outline_rounded,
            onPressed: () {},
          ),

          const SizedBox(height: 24),

          ButtonSignout(onPressed: () {}),

          const SizedBox(height: 16),
        ],
      ),
    );
  }
}
