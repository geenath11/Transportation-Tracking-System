import 'package:flutter/material.dart';
import 'package:transportation_tracking_system/core/theme/app_colors.dart';

class ButtonSignout extends StatelessWidget {
  final VoidCallback onPressed;
  final double? width;
  final double height;

  const ButtonSignout({
    super.key,
    required this.onPressed,
    this.width,
    this.height = 56,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width ?? MediaQuery.sizeOf(context).width * 0.9,
      height: height,
      child: FilledButton(
        onPressed: onPressed,
        style: FilledButton.styleFrom(
          backgroundColor:  Color(0xFFE53E3E),
          foregroundColor: Color(0xFFFFFFFF),
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(45),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const Icon(Icons.logout, size: 20, color: Colors.white),
            const SizedBox(width: 18),

            Text(
              "Sign Out",
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                fontFamily: "Poppins",
                color: Colors.white,
              ),
            ),
            const Spacer(),
            const Icon(
              Icons.arrow_forward_ios_rounded,
              size: 14,
              color: Colors.white,
            ),
          ],
        ),
      ),
    );
  }
}
