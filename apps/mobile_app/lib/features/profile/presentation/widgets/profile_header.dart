import 'package:flutter/material.dart';
import 'package:transportation_tracking_system/core/theme/app_colors.dart';

class ProfileHeader extends StatelessWidget {
  final String name;
  final String role;
  final String number;
  final String? imagePath;

  const ProfileHeader({
    super.key,
    required this.name,
    required this.role,
    required this.number,
    this.imagePath,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(24, 55, 24, 24),
      decoration: const BoxDecoration(
        color:   Color(0xFF363AC6),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(45),
          bottomRight: Radius.circular(45),
        ),
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 45,
            backgroundColor: Colors.white,
            child: CircleAvatar(
              radius: 40,
              backgroundColor: const Color(0xFFE2E3FC),
              backgroundImage: imagePath != null
                  ? AssetImage(imagePath!)
                  : null,
              child: imagePath == null
                  ? Icon(Icons.person, size: 45, color: AppColors.primary)
                  : null,
            ),
          ),
          const SizedBox(width: 20),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                name,
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w600,
                  fontFamily: 'Poppins',
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 4),
              Wrap(
                spacing: 16,
                children: [
                  Text(
                    role,
                    style: TextStyle(
                      fontSize: 14,
                      fontFamily: 'Poppins',
                      color: Colors.white.withValues(alpha: 0.75),
                    ),
                  ),
                  Text(
                    number,
                    style: TextStyle(
                      fontSize: 14,
                      fontFamily: 'Poppins',
                      color: Colors.white.withValues(alpha: 0.75),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
