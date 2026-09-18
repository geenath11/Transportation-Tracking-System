import 'package:flutter/material.dart';
import 'package:transportation_tracking_system/core/services/user_profile_service.dart';
import 'package:transportation_tracking_system/core/theme/app_colors.dart';
import 'package:transportation_tracking_system/core/theme/app_text_styles.dart';

class ProfileHeader extends StatelessWidget {
  final String? imagePath;

  const ProfileHeader({super.key, this.imagePath});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 210,
      child: Stack(
        clipBehavior: Clip.none,
        alignment: Alignment.topCenter,
        children: [
          Container(
            width: double.infinity,
            height: 150,
            decoration: const BoxDecoration(
              gradient: SweepGradient(
                colors: [
                  AppColors.primary,
                  Color(0xFF1F228E),
                  AppColors.primary,
                  AppColors.primary,
                ],
              ),
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(45),
                bottomRight: Radius.circular(45),
              ),
            ),
          ),
          Positioned(
            top: 50,
            child: CircleAvatar(
              radius: 60,
              backgroundColor: Colors.white,
              child: CircleAvatar(
                radius: 55,
                backgroundColor: const Color(0xFFEEF0FF),
                backgroundImage: imagePath != null
                    ? AssetImage(imagePath!)
                    : null,
                child: imagePath == null
                    ? const Icon(
                        Icons.person,
                        size: 55,
                        color: AppColors.primary,
                      )
                    : null,
              ),
            ),
          ),
          Positioned(
            top: 169,
            left: 24,
            right: 24,
            child: Column(
              children: [
                Text(
                  UserProfileService.instance.name,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.semiBold.copyWith(
                    fontSize: 21,
                    color: const Color(0xFF202124),
                  ),
                ),
                const SizedBox(height: 5),
                Wrap(
                  alignment: WrapAlignment.center,
                  spacing: 10,
                  runSpacing: 2,
                  children: [
                    Text(
                      UserProfileService.instance.role,
                      style: AppTextStyles.semiBold.copyWith(
                        fontSize: 14,
                        color: const Color(0xFF4B4D55),
                      ),
                    ),
                    Text(
                      UserProfileService.instance.phone,
                      style: AppTextStyles.semiBold.copyWith(
                        fontSize: 14,
                        color: const Color(0xFF4B4D55),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
