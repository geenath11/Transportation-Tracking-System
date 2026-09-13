import 'package:flutter/material.dart';
import 'package:transportation_tracking_system/core/theme/app_colors.dart';
import 'package:transportation_tracking_system/features/profile/presentation/widgets/button_profile.dart';
import 'package:transportation_tracking_system/features/profile/presentation/widgets/profile_header.dart';
import 'package:transportation_tracking_system/features/profile/presentation/widgets/button_signout.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          ProfileHeader(
            ),
          const SizedBox(height: 30),
          Center(
            child: ButtonProfile(
              text: "Account",
              icon: Icons.account_circle_rounded,
              onPressed: () {},
            ),
          ),
          SizedBox(height: 8),
          Center(
            child: ButtonProfile(
              text: "Payment Information",
              icon: Icons.info_rounded,
              onPressed: () {},
            ),
          ),
          SizedBox(height: 8),
          Center(
            child: ButtonProfile(
              text: "Wallet Balance",
              icon: Icons.account_balance_wallet_rounded,
              onPressed: () {},
            ),
          ),
          SizedBox(height: 8),
          Center(
            child: ButtonProfile(
              text: "Booking Profile",
              icon: Icons.history,
              onPressed: () {},
            ),
          ),
          SizedBox(height: 8),
          Center(
            child: ButtonProfile(
              text: "Notification",
              icon: Icons.circle_notifications_rounded,
              onPressed: () {},
            ),
          ),
          Spacer(),
          Center(
            child: ButtonProfile(
              text: "Privacy Policy",
              icon: Icons.privacy_tip_rounded,
              onPressed: () {},
            ),
          ),
          SizedBox(height: 8),
          Center(
            child: ButtonProfile(
              text: "About Us",
              icon: Icons.info_outline_rounded,
              onPressed: () {},
            ),
          ),
          Spacer(),
          Center(child: ButtonSignout(onPressed: () {})),
          SizedBox(height: 8),
        ],
      ),
    );
  }
}
