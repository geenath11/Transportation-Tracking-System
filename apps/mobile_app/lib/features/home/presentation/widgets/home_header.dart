import "package:flutter/material.dart";
import "package:transportation_tracking_system/core/theme/app_colors.dart";
import "package:transportation_tracking_system/core/theme/app_text_styles.dart";

Widget buildHeader() {
  return Row(
    crossAxisAlignment: CrossAxisAlignment.center,
    children: [
      Expanded(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Hello, Ravindu",
              style: AppTextStyles.semiBold.copyWith(
                fontSize: 18,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              "Where to next?",
              style: AppTextStyles.bold.copyWith(
                fontSize: 26,
                color: AppColors.primary,
              ),
            ),
          ],
        ),
      ),
      Container(
        width: 48,
        height: 48,
        decoration: BoxDecoration(
          color: AppColors.primary.withValues(alpha: 0.08),
          shape: BoxShape.circle,
        ),
        child: IconButton(
          onPressed: () {},
          icon: const Icon(
            Icons.notifications_none_rounded,
            size: 26,
          ),
          color: AppColors.primary,
          padding: EdgeInsets.zero,
        ),
      ),
    ],
  );
}