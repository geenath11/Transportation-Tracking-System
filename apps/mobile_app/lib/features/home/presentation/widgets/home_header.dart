import "package:flutter/material.dart";
import "package:transportation_tracking_system/core/theme/app_colors.dart";
import "package:transportation_tracking_system/core/theme/app_text_styles.dart";

Widget buildHeader() {
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Hello, Ravindu",
            style: AppTextStyles.semiBold.copyWith(fontSize: 20),
          ),

          Text(
            "Where to next?",
            style: AppTextStyles.bold.copyWith(
              fontSize: 30,
              color: AppColors.primary,
            ),
          ),
        ],
      ),

      IconButton(
        icon: const Icon(
          Icons.notifications_none,
          color: Colors.black,
          size: 40,
        ),

        onPressed: () {},
      ),
    ],
  );
}
