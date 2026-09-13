import 'package:flutter/material.dart';

import '../../../passenger/presentation/screen/map_search_page.dart';
import "package:transportation_tracking_system/core/theme/app_colors.dart";

Widget buildSearchBar(BuildContext context) {
  return Material(
    color: Colors.transparent,
    child: InkWell(
      borderRadius: BorderRadius.circular(18),
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const MapSearchPage(),
          ),
        );
      },
      child: Container(
        height: 58,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        decoration: BoxDecoration(
          color: Colors.grey.shade100,
          borderRadius: BorderRadius.circular(30),
          border: Border.all(
            color: Colors.grey.shade200,
          ),
        ),
        child: Row(
          children: [
            Icon(
              Icons.search_rounded,
              size: 25,
              color: AppColors.primary,
            ),

            const SizedBox(width: 12),

            Text(
              'Where do you want to go?',
              style: TextStyle(
                fontSize: 15,
                color: Colors.grey.shade600,
                fontFamily: 'Poppins',
              ),
            ),

            const Spacer(),

            Icon(
              Icons.arrow_forward_ios_rounded,
              size: 16,
              color: Colors.grey.shade500,
            ),
          ],
        ),
      ),
    ),
  );
}